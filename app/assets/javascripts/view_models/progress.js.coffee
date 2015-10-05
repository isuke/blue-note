$ ->
  window.progress = new Vue
    el: '#progress'
    data:
      projectId: undefined
      dispatcher: undefined
      channel: undefined
      listsFeatureView: 'featureList'
    compiled: ->
      @dispatcher = new WebSocketRails('localhost:3000/websocket')
      @channel = @dispatcher.subscribe("project_#{@projectId}")
      @channel.bind 'features.got', (feature) =>
        @$.listsFeatureView.addFeature(feature)

  page hashbang: true, dispatch: false
  page 'featureList', (ctx) ->
    progress.listsFeatureView = 'featureList'
  page 'featureShow/:id', (ctx) ->
    progress.listsFeatureView = 'featureShow'
    Vue.nextTick ->
      progress.$.listsFeatureView.editMode = false
      progress.$.listsFeatureView.featureId = ctx.params.id
