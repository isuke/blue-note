WebsocketRails::EventMap.describe do
  namespace :features do
    subscribe :get   , to: Websocket::FeaturesController, with_method: :get
    subscribe :delete, to: Websocket::FeaturesController, with_method: :delete
  end
end
