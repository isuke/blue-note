$ ->
  window.home = new Vue
    el: '#home'
    data:
      currentForm: undefined
      email:    undefined
      password: undefined
    methods:
      showSignUpModal: ->
        @$.signUpModal.show()
