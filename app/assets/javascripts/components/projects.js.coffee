$ ->
  Vue.component 'projects',
    template: '#projects'
    inherit: true
    data: ->
      projectList: []
      project:
        name: ''
    compiled: ->
      @load()
    methods:
      load: ->
        $.ajax "/api/projects.json"
          .done (response) =>
            @projectList = response
          .fail (response) =>
            console.error response
      linkTo: (project) ->
        projectId = project.$el.id.match(/project_(\d+)/)[1]
        document.location = "/projects/#{projectId}/progress"
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
            @load()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
