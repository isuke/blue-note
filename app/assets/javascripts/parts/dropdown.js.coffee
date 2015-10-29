class Dropdown
  @hide_all: ->
    $('.dropdown__content').hide()
  @show: (item) ->
    @hide_all()
    $(item).closest('.droodown').find('.dropdown__content').show()

$ ->
  Dropdown.hide_all()

  $(document).on 'click', (e) ->
    Dropdown.hide_all()
  $(document).on 'click', '.dropdown__btn', (e) ->
    e.stopPropagation()
    Dropdown.show(@)
  $(document).on 'click', '.dropdown__content', (e) ->
    e.stopPropagation()
