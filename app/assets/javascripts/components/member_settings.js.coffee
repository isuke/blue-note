$ ->
  Vue.component 'membersSettings',
    template: '#members_settings'
    inherit: true
    data: ->
      member:
        email: ''
        role:  'general'
      memberList: []
    compiled: ->
      @load()
    methods:
      load: ->
        $.ajax "/api/projects/#{@projectId}/members.json"
          .done (response) =>
            @memberList = response
          .fail (response) =>
            console.error response
      submit: (e) ->
        try
          e.preventDefault()
          submit = $('.members_settings__member_new__submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/projects/#{@projectId}/members.json"
            type: 'POST'
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
            toastr.error(json.full_messages, json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
