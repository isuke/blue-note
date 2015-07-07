$ ->
  Vue.component 'featureList',
    template: '#feature_list'
    props: ['project-id']
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
      $.ajax "/projects/#{@projectId}/features.json"
        .done (response) =>
          @featureList = response
          @filteredFeatureList = response
        .fail (response) =>
          console.log response
    computed:
      filteredFeatureList: ->
        @filter @featureList

  window.progress = new Vue
    el: '#progress'
    data:
      projectId: undefined
