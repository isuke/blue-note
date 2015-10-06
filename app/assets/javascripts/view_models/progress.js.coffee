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
        @$.division3View.addOrUpdateFeature(data) if @$.division3View.addOrUpdateFeature

  page hashbang: true, dispatch: false
  page 'featureNew', (ctx) ->
    progress.division2View = 'featureNew'
  page 'featureShow/:id', (ctx) ->
    progress.division2View = 'featureShow'
    Vue.nextTick ->
      progress.$.division2View.editMode = false
      progress.$.division2View.featureId = ctx.params.id
