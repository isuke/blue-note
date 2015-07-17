class Websocket::FeaturesController < WebsocketRails::BaseController
  def get
    @feature = Feature.find(message[:id])
    WebsocketRails["project_#{message[:project_id]}"].trigger(:got, @feature, namespace: :features)
  end
end
