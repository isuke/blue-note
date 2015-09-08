$ ->
  Vue.component 'projectList',
    template: '#project_list'
    inherit: true
    data: ->
      projectList: []
    compiled: ->
      $.ajax "/api/projects.json"
        .done (response) =>
          @projectList = response
        .fail (response) =>
          console.log response
    methods:
      linkTo: (project) ->
        projectId = project.$el.id.match(/project_(\d+)/)[1]
        document.location = "/projects/#{projectId}/progress"
