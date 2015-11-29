$ ->
  window.home = new Vue
    el: '#home'
    methods:
      showSignUpModal: -> @$refs.signUpModal.show()
