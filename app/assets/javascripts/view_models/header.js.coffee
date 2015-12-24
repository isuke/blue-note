$ ->
  window.header = new Vue
    el: '#header'
    data:
      showProjectMenu: false
      showUserMenu: false
    methods:
      showLoginModal: -> @$refs.loginModal.show()
      logout: ->
        $.ajax
          url: '/api/logout.json'
          type: 'DELETE'
        .done (response) =>
          toastr.success('', response.message, {timeOut: 0})
          document.location = '/'
        .fail (response) =>
          json = response.responseJSON
          toastr.error('', json.message, {timeOut: 0})
