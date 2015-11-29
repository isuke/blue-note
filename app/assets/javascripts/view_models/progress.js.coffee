$ ->
  window.progress = new Vue
    el: '#progress'
    data:
      userId: undefined
      projectId: undefined
      dispatcher: undefined
      channel: undefined
      division2View: 'featureNew'
      division3View: 'featureList'
    compiled: ->
      @dispatcher = new WebSocketRails('localhost:3000/websocket')
      @channel = @dispatcher.subscribe("project_#{@projectId}")

      @channel.bind 'features.got', (data) =>
        @.$broadcast('addOrUpdateFeatures', data)

      @channel.bind 'features.deleted', (data) =>
        @.$broadcast('removeFeature', data)

  page hashbang: true, dispatch: false
  page 'featureNew', (ctx) ->
    progress.division2View = 'featureNew'
  page 'featureShow/:id', (ctx) ->
    progress.division2View = 'featureShow'
    Vue.nextTick =>
      progress.$refs.division2view.editMode = false
      progress.$refs.division2view.featureId = ctx.params.id
