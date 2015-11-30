$ ->
  Vue.component 'projects',
    template: '#projects'
    props: ['currentUserId']
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
        document.location = "/projects/#{project.id}/progress"
      submit: (e) ->
        e.preventDefault()
        submit = $('.project_new__submit')
        submit.prop('disabled', true)
        $.ajax
          url: '/api/projects.json'
          type: 'POST'
          timeout: 10000
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
        .always () =>
          submit.prop('disabled', false)
