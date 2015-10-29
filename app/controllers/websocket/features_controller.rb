class Websocket::FeaturesController < WebsocketRails::BaseController
  def get
    @user    = User.find(message[:user_id])
    @features = Feature.where(id: message[:ids])
    data = { user: @user, features: @features }
    WebsocketRails["project_#{message[:project_id]}"].trigger(:got, data, namespace: :features)
  end

  def delete
    @user = User.find(message[:user_id])
    data  = { user: @user, ids: message[:ids] }
    WebsocketRails["project_#{message[:project_id]}"].trigger(:deleted, data, namespace: :features)
  end
end
