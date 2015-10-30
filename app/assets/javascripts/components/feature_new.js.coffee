$ ->
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
            @dispatcher.trigger('features.get', {user_id: @userId, project_id: @projectId, ids: [response.id]})
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
