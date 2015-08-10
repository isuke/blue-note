Vue.modules.modalable = {
  data: ->
    active: false
  methods:
    show: ->
      @active = true
    hide: ->
      @active = false
    toggle: ->
      @active = !@active
}
