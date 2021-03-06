class Websocket::FeaturesController < WebsocketRails::BaseController
  def get
    @user    = User.find(message[:user_id])
    features = Feature.where(id: message[:ids]).order(:id)
    data = { user: @user, features: JSON.parse(Rabl.render(features, 'features')), show_message: message[:show_message] }
    WebsocketRails["project_#{message[:project_id]}"].trigger(:got, data, namespace: :features)
  end

  def delete
    @user = User.find(message[:user_id])
    data  = { user: @user, ids: message[:ids], show_message: message[:show_message] }
    WebsocketRails["project_#{message[:project_id]}"].trigger(:deleted, data, namespace: :features)
  end
end
