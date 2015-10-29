$ ->
  Vue.component 'featureList',
    template: '#feature_list'
    mixins: [Vue.modules.filterable]
    inherit: true
    data: ->
      featureList: []
      queryStr: 'status:todo,doing'
      schema:
        title:  'like'
        point:  'int'
        status: 'enum'
      status: undefined
    compiled: ->
      @load()
    computed:
      filteredFeatureList: ->
        @filter @featureList
      selectedFeatureList: ->
        _.filter @filteredFeatureList, (feature) -> feature.selected
    methods:
      load: ->
        $.ajax "/api/projects/#{@projectId}/features.json"
          .done (response) =>
            @featureList = response
            $.each @featureList, (i, feature) ->
              feature.$add('selected', false)
          .fail (response) =>
            console.error response
      deleteAll: ->
        return if @selectedFeatureList.length <= 0
        if confirm "delete #{@selectedFeatureList.length} feature(s). Are you sure?"
          $.ajax
            url: "/api/projects/#{@projectId}/features/destroy_all.json"
            type: 'DELETE'
            data:
              ids: _.pluck @selectedFeatureList, 'id'
          .done (response) =>
            toastr.success('', response.message)
            @dispatcher.trigger('features.delete', { user_id: @userId, project_id: @projectId, ids: response.ids })
          .fail (response) =>
            json = response.responseJSON
            toastr.error('', response.message, { timeOut: 0 })
      updateStatus: ->
        return if @selectedFeatureList.length <= 0
        params = []
        $.each $.extend(true, {}, @selectedFeatureList), (index, feature) =>
          params.push _.extend(feature, status: @status)
        $.ajax
          url: "/api/projects/#{@projectId}/features/update_all.json"
          type: 'PATCH'
          dataType: 'json'
          contentType: 'application/json'
          data:
            JSON.stringify(features: params)
        .done (response) =>
          toastr.success('', response.message)
          @dispatcher.trigger('features.get', {user_id: @userId, project_id: @projectId, ids: response.ids})
        .fail (response) =>
          json = response.responseJSON
          toastr.error('', response.message, { timeOut: 0 })
      addOrUpdateFeatures: (data) ->
        $.each data.features, (index, feature) =>
          if _.findKey @featureList, {id: feature.id}
            @updateFeature data.user, feature
          else
            @addFeature data.user, feature
      addFeature: (user, feature) ->
        if user.id.toString() != @userId
          toastr.info('', "#{user.name}: created #{feature.title}", { timeOut: 0 })
        newFeature = feature
        newFeature.$add('selected', false)
        @featureList.push(newFeature)
      updateFeature: (user, feature) ->
        if user.id.toString() != @userId
          toastr.info('', "#{user.name}: updated #{feature.title}", { timeOut: 0 })

        index = _.findIndex @featureList, {id: feature.id}
        feature.$add('selected', @featureList[index].selected)
        @featureList.$set index, feature
      removeFeature: (data) ->
        if data.user.id.toString() != @userId
          toastr.info('', "#{data.user.name}: deleted feature", { timeOut: 0 })
        @featureList = _.reject @featureList, (feature) ->
          _.includes data.ids, feature.id.toString()
      show: (feature) ->
        featureId = feature.$el.id.match(/feature_(\d+)/)[1]
        page "featureShow/#{featureId}"
