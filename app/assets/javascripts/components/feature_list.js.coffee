$ ->
  Vue.component 'featureList',
    template: '#feature_list'
    mixins: [Vue.modules.filterable]
    inherit: true
    data: ->
      featureList: []
      query: { status: ['todo', 'doing'] }
      filterStatus:
        todo:  true
        doing: true
        done:  false
      schema:
        priority: 'int'
        title:    'like'
        point:    'int'
        status:   'eq'
      status: undefined
    compiled: ->
      @load()
    ready: ->
      new Sortable document.getElementById('feature_list__items--exists_priority'),
        group:
          name: 'feature_list__items--exists_priority'
          put: ['feature_list__items--not_exists_priority']
        chosenClass: 'feature_list__items__item--chosen'
        animation: 150
        sort: true
        onAdd: (evt) => @sort(evt, false)
        onUpdate: (evt) => @sort(evt, false)
        onRemove: (evt) => @sort(evt, true)
      new Sortable document.getElementById('feature_list__items--not_exists_priority'),
        group:
          name: 'feature_list__items--not_exists_priority'
          put: ['feature_list__items--exists_priority']
        chosenClass: 'feature_list__items__item--chosen'
        animation: 150
        sort: false
    computed:
      filteredFeatureList: ->
        @filter @featureList
      selectedFeatureList: ->
        _.filter @filteredFeatureList, (feature) -> feature.selected
    watch:
      filterStatus:
        handler: ->
          temp = []
          $.each @filterStatus, (k, v) -> temp.push(k) if v
          @query.status = temp
        deep: true
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
            @dispatcher.trigger('features.delete', { user_id: @userId, project_id: @projectId, ids: response.ids, show_message: true })
          .fail (response) =>
            json = response.responseJSON
            toastr.error('', json.message, { timeOut: 0 })
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
          toastr.error('', json.message, { timeOut: 0 })
      addOrUpdateFeatures: (data) ->
        $.each data.features, (index, feature) =>
          if _.findKey @featureList, {id: feature.id}
            @updateFeature data.user, feature, data.show_message
          else
            @addFeature data.user, feature, data.show_message
      addFeature: (user, feature, show_message = true) ->
        if show_message && user.id.toString() != @userId
          toastr.info('', "#{user.name}: created #{feature.title}", { timeOut: 0 })
        newFeature = feature
        newFeature.$add('selected', false)
        @featureList.push(newFeature)
      updateFeature: (user, feature, show_message = true) ->
        if show_message && user.id.toString() != @userId
          toastr.info('', "#{user.name}: updated #{feature.title}", { timeOut: 0 })
        index = _.findIndex @featureList, {id: feature.id}
        feature.$add('selected', @featureList[index].selected)
        @featureList.$set index, feature
      removeFeature: (data, show_message = true) ->
        if show_message && data.user.id.toString() != @userId
          toastr.info('', "#{data.user.name}: deleted feature", { timeOut: 0 })
        @featureList = _.reject @featureList, (feature) ->
          _.includes data.ids, feature.id.toString()
      show: (feature) ->
        featureId = feature.$el.id.match(/feature_(\d+)/)[1]
        page "featureShow/#{featureId}"
      sort: (evt, remove) ->
        featureId = evt.item.id.match(/feature_(\d+)/)[1]

        insert_at = null
        insert_at = evt.newIndex+1 unless remove

        $.ajax
          url: "/api/features/#{featureId}/update_priority.json"
          type: 'PATCH'
          dataType: 'json'
          contentType: 'application/json'
          data:
            JSON.stringify(insert_at: insert_at)
        .done (response) =>
          toastr.success('', response.message)
          @dispatcher.trigger('features.get', { user_id: @userId, project_id: @projectId, ids: response.ids, show_message: false })
        .fail (response) =>
          json = response.responseJSON
          window.aaa = response
          toastr.error('', json.message, { timeOut: 0 })
