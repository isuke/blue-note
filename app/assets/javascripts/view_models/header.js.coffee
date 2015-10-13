$ ->
  window.header = new Vue
    el: '#header'
    data:
      showProjectMenu: false
      showUserMenu: false
    methods:
      toggleProjectMenu: -> @showProjectMenu = !@showProjectMenu
      toggleUserMenu:    -> @showUserMenu    = !@showUserMenu
      showLoginModal: -> @$.loginModal.show()
      logout: ->
        $.ajax
          url: '/api/logout.json'
          type: 'DELETE'
        .done (response) =>
          toastr.success('', response.message, { timeOut: 0 })
          document.location = '/'
        .fail (response) =>
          json = response.responseJSON
          toastr.error('', json.message, { timeOut: 0 })

  $(document).on 'click', (e) ->
    window.header.showProjectMenu = false unless e.target.classList.contains('js-show_project_menu_btn')
    window.header.showUserMenu    = false unless e.target.classList.contains('js-show_user_menu_btn')
    return true
