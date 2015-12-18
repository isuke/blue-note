$ ->
  window.progress = new Vue
    el: '#progress'
    data:
      userId: undefined
      projectId: undefined
      dispatcher: undefined
      channel: undefined
      sidemenuView: 'featureNew'
      division3View: 'featureList'
    compiled: ->
      @dispatcher = new WebSocketRails('localhost:3000/websocket')
      @channel = @dispatcher.subscribe("project_#{@projectId}")

      @channel.bind 'features.got', (data) =>
        @.$broadcast('addOrUpdateFeatures', data)

      @channel.bind 'features.deleted', (data) =>
        @.$broadcast('removeFeature', data)
    ready: ->
      $('.sidemenu').fixedsticky();

  page hashbang: true, dispatch: false
  page 'featureNew', (ctx) ->
    progress.sidemenuView = 'featureNew'
  page 'featureShow/:id', (ctx) ->
    progress.sidemenuView = 'featureShow'
    Vue.nextTick =>
      progress.$refs.sidemenuview.editMode = false
      progress.$refs.sidemenuview.featureId = ctx.params.id
