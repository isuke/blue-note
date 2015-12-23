$ ->
  Vue.component 'membersSettings',
    template: '#members_settings'
    props: ['userId', 'projectId', 'role']
    data: ->
      member:
        email: ''
        role: 'general'
      memberList: []
    watch:
      projectId: -> @load()
    methods:
      load: ->
        $.ajax "/api/projects/#{@projectId}/members.json"
          .done (response) =>
            @memberList = response
          .fail (response) =>
            console.error response
      submit: (e) ->
        e.preventDefault()
        submit = $('.members_settings__member_new__submit')
        submit.prop('disabled', true)
        $.ajax
          url: "/api/projects/#{@projectId}/members.json"
          type: 'POST'
          timeout: 10000
          data:
            member:
              email: @member.email
              role: @member.role
        .done (response) =>
          toastr.success('', response.message)
          @member.email = ''
          @load()
        .fail (response) =>
          json = response.responseJSON
          toastr.error(json.full_messages, json.message, {timeOut: 0})
        .always =>
          submit.prop('disabled', false)
