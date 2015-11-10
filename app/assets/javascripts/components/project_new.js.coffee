$ ->
  Vue.component 'projectNew',
    template: '#project_new'
    inherit: true
    data: ->
      project:
        name: ''
    methods:
      submit: (e) ->
        try
          e.preventDefault()
          submit = $('.project_new__submit')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/projects.json'
            type: 'POST'
            data:
              project:
                name: @project.name
          .done (response) =>
            toastr.success('', response.message)
            @project.name = ''
            window.dashboard.$.projectList.load() if window.dashboard.$.projectList
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
