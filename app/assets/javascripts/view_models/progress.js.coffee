$ ->
  window.progress = new Vue
    el: '#progress'
    data:
      projectId: undefined
      dispatcher: undefined
      channel: undefined
    compiled: ->
      @dispatcher = new WebSocketRails('localhost:3000/websocket')
      @channel = @dispatcher.subscribe("project_#{@projectId}")
      @channel.bind 'features.got', (feature)=>
        @$.featureList.addFeature(feature)
