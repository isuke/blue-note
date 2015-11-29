$ ->
  Vue.component 'signUpModal',
    template: '#sign_up_modal'
    mixins: [Vue.modules.modalable]
    data: ->
      user:
        name: ''
        email: ''
        password: ''
        passwordConfirmation: ''
    methods:
      submit: (e)->
          e.preventDefault()
          submit = $('#sign_up_modal_submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/sign_up.json"
            type: 'POST'
            timeout: 10000
            data:
              user:
                name: @user.name
                email: @user.email
                password: @user.password
                password_confirmation: @user.passwordConfirmation
          .done (response) =>
            toastr.success('', response.message, { timeOut: 0 })
            document.location = '/'
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
          .always () =>
            submit.prop('disabled', false)
