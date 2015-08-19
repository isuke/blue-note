$ ->
  window.home = new Vue
    el: '#home'
    methods:
      showSignUpModal: ->
        @$.signUpModal.show()
