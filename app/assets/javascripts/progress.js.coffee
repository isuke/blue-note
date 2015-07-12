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
      $.ajax "/api/projects/#{@projectId}/features.json"
        .done (response) =>
          @featureList = response
          @filteredFeatureList = response
        .fail (response) =>
          console.log response
    computed:
      filteredFeatureList: ->
        @filter @featureList

  Vue.component 'featureNew',
    template: '#feature_new'
    props: ['project-id']
    inherit: true
    data: ->
      feature:
        title: ''
        point: ''
    methods:
      submit: (e)->
        e.preventDefault()
        submit = $('#new_feature_submit')
        submit.prop('disabled', true)
        $.ajax
          url: "/api/projects/#{@projectId}/features.json"
          type: 'POST'
          data:
            feature:
              title: @feature.title
              point: @feature.point
        .done (response) =>
          toastr.success('', response.message)
          @feature.title = ''
          @feature.point = ''
        .fail (response) =>
          json = response.responseJSON
          toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        submit.prop('disabled', false)

  window.progress = new Vue
    el: '#progress'
    data:
      projectId: undefined
