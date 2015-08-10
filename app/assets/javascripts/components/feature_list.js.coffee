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
          console.log response
    computed:
      filteredFeatureList: ->
        @filter @featureList
    methods:
      addFeature: (feature)->
        @featureList.push(feature)
      toggle: (feature)->
        if feature.selected?
          feature.selected = !feature.selected
        else
          feature.$add('selected', true)
