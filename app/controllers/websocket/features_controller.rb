class Websocket::FeaturesController < WebsocketRails::BaseController
  def get
    @user    = User.find(message[:user_id])
    @feature = Feature.find(message[:id])
    data = { user: @user, feature: @feature }
    WebsocketRails["project_#{message[:project_id]}"].trigger(:got, data, namespace: :features)
  end
end
