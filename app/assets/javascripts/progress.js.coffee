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

  Vue.component 'featureNew',
    template: '#feature_new'
    inherit: true
    data: ->
      feature:
        title: ''
        point: ''
    methods:
      submit: (e)->
        try
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
            @dispatcher.trigger('features.get', {project_id: @projectId, id: response.id})
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)

  window.progress = new Vue
    el: '#progress'
    data:
      projectId: undefined
      dispatcher: undefined
      channel: undefined
    compiled: ->
      @dispatcher = new WebSocketRails('localhost:3000/websocket')
      @channel = @dispatcher.subscribe("project_#{@projectId}")
      @channel.bind 'features.got', (feature)=>
        @$.featureList.addFeature(feature)
