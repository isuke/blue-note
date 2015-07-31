WebsocketRails::EventMap.describe do
  namespace :features do
    subscribe :get, to: Websocket::FeaturesController, with_method: :get
  end
end
