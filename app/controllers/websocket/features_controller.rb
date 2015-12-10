class Websocket::FeaturesController < WebsocketRails::BaseController
  def get
    @user    = User.find(message[:user_id])

    data = { user: @user, features: JSON.parse(feature_json(message[:ids])), show_message: message[:show_message] }
    WebsocketRails["project_#{message[:project_id]}"].trigger(:got, data, namespace: :features)
  end

  def delete
    @user = User.find(message[:user_id])
    data  = { user: @user, ids: message[:ids], show_message: message[:show_message] }
    WebsocketRails["project_#{message[:project_id]}"].trigger(:deleted, data, namespace: :features)
  end

private

  # HACK: use json/features.json.jbuilder
  # rubocop:disable Metrics/AbcSize
  def feature_json(ids)
    Jbuilder.new do |json|
      json.array!(Feature.where(id: ids)) do |feature|
        json.id       feature.id
        json.title    feature.title
        json.status   feature.status
        json.priority feature.priority
        json.point    feature.point
        json.iteration_number feature.iteration.try(:number)
        json.created_at feature.created_at
        json.updated_at feature.updated_at
      end
    end.target!
  end
  # rubocop:enable Metrics/AbcSize
end
