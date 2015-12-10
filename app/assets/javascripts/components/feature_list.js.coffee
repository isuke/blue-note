$ ->
  Vue.component 'featureList',
    template: '#feature_list'
    mixins: [Vue.modules.filterable]
    props: ['userId', 'projectId', 'dispatcher', 'channel']
    data: ->
      featureList: []
      IterationList: []
      query: { status: ['todo', 'doing'] }
      schema:
        priority: 'int'
        title:    'like'
        point:    'int'
        status:   'eq'
        iteration_number: 'int'
      action:
        status: undefined
        iteration: undefined
    ready: ->
      new Sortable document.getElementById('feature_list__items__list'),
        chosenClass: 'feature_list__items__list__item--chosen'
        animation: 150
        sort: true
        onSort: (evt) => @sort(evt)
    computed:
      filteredFeatureList: ->
        @filter @featureList
      selectedFeatureList: ->
        _.filter @filteredFeatureList, (feature) -> feature.selected
    watch:
      projectId: -> @load()
      filteredFeatureList:
        handler: (val) -> Vue.nextTick => @setIterations(val)
        deep: true
    events:
      addOrUpdateFeatures: (data) ->
        $.each data.features, (index, feature) =>
          if _.findKey @featureList, {id: feature.id}
            @updateFeature data.user, feature, data.show_message
          else
            @addFeature data.user, feature, data.show_message
      removeFeature: (data, show_message = true) ->
        if show_message && data.user.id.toString() != @userId
          toastr.info('', "#{data.user.name}: deleted feature", { timeOut: 0 })
        @featureList = _.reject @featureList, (feature) ->
          _.includes data.ids, feature.id.toString()
    methods:
      load: ->
        @loadFeatureList()
        @loadIterationList()
      loadFeatureList: ->
        $.ajax "/api/projects/#{@projectId}/features.json"
          .done (response) =>
            $.each response, (i, feature) =>
              feature.selected = false
            @featureList = response
          .fail (response) =>
            console.error response
      loadIterationList: ->
        $.ajax "/api/projects/#{@projectId}/iterations.json"
          .done (response) =>
            @iterationList = response
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
        $.each @selectedFeatureList, (index, feature) =>
          params.push { id: feature.id, status: @action.status }
        @updateFeatures(params)
      updateIterations: ->
        return if @selectedFeatureList.length <= 0
        params = []
        $.each @selectedFeatureList, (index, feature) =>
          params.push { id: feature.id, iteration_id: @action.iteration }
        @updateFeatures(params)
      updateFeatures: (params) ->
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
      addFeature: (user, feature, show_message = true) ->
        if show_message && user.id.toString() != @userId
          toastr.info('', "#{user.name}: created #{feature.title}", { timeOut: 0 })
        newFeature = feature
        newFeature.selected = false
        @featureList.push(newFeature)
      updateFeature: (user, feature, show_message = true) ->
        if show_message && user.id.toString() != @userId
          toastr.info('', "#{user.name}: updated #{feature.title}", { timeOut: 0 })
        index = _.findIndex @featureList, {id: feature.id}
        updateFeature = feature
        updateFeature.selected = @featureList[index].selected
        @featureList.$set index, feature
      show: (feature) ->
        page "featureShow/#{feature.id}"
      sort: (evt) ->
        featureId = evt.item.id.match(/feature_(\d+)/)[1]

        insert_at = evt.newIndex + 1

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
          toastr.error('', json.message, { timeOut: 0 })

      setIterations: (featureList) ->
        ite = d3.select('.feature_list__items__iteration')
        ite.selectAll('div').remove()

        pre_feature = null
        height = 0
        border_height = 1
        $.each _.sortBy(featureList, 'priority'), (index, feature) =>
          pre_feature = feature unless pre_feature?
          if pre_feature.iteration_number != feature.iteration_number
            @setIteration(ite, pre_feature, height)
            height = 0
            pre_feature = feature

          height += $("#feature_#{feature.id}").height() + border_height

        @setIteration(ite, pre_feature, height)
      setIteration: (iteration_div, feature, height) ->
        text = feature.iteration_number ? 'None'
        iteration_div.append('div')
          .style('height', "#{height}px")
          .attr('class', 'feature_list__items__iterations__item')
          .append('span')
          .attr('class', 'feature_list__items__iterations__item__number')
          .text(text)
