$ ->
  Vue.component 'loginModal',
    template: '#login_modal'
    mixins: [Vue.modules.modalable]
    data: ->
      user_session:
        email: ''
        password: ''
    methods:
      submit: (e) ->
        e.preventDefault()
        submit = $('#login_modal_submit')
        submit.prop('disabled', true)
        $.ajax
          url: '/api/login.json'
          type: 'POST'
          timeout: 10000
          data:
            user_session:
              email: @user_session.email
              password: @user_session.password
        .done (response) =>
          toastr.success('', response.message, {timeOut: 0})
          document.location = '/dashboard'
        .fail (response) =>
          json = response.responseJSON
          toastr.error('', json.message, {timeOut: 0})
        .always =>
          submit.prop('disabled', false)
