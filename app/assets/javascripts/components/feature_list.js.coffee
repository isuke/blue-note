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
    compiled: ->
      $.ajax "/api/projects/#{@projectId}/features.json"
        .done (response) =>
          @featureList = response
          @filteredFeatureList = response
        .fail (response) =>
          console.error response
    computed:
      filteredFeatureList: ->
        @filter @featureList
    methods:
      addOrUpdateFeature: (data) ->
        if _.findKey @featureList, {id: data.feature.id}
          @updateFeature data
        else
          @addFeature data
      addFeature: (data) ->
        if data.user.id.toString() != @userId
          toastr.info('', "#{data.user.name}: created #{data.feature.title}")
        @featureList.push(data.feature)
      updateFeature: (data) ->
        if data.user.id.toString() != @userId
          toastr.info('', "#{data.user.name}: updated #{data.feature.title}")
        index = _.findIndex @featureList, {id: data.feature.id}
        @featureList.$set index, data.feature
      toggle: (feature) ->
        if feature.selected?
          feature.selected = !feature.selected
        else
          feature.$add('selected', true)
      show: (feature) ->
        featureId = feature.$el.id.match(/feature_(\d+)/)[1]
        page "featureShow/#{featureId}"
