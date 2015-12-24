class Api::FeaturesController < Api::ApiController
  include MemberAuthorizeConcern
  include FeaturesControllerEachModelsUpdate

  before_action :set_project, only: [:index, :create, :update_all, :destroy_all]
  before_action :set_feature, only: [:show, :update, :update_priority]
  before_action -> { member_authorize @project }, only: [:index, :create, :update_all, :destroy_all]

  def index
    @features = @project.features.includes(:iteration).order(:id)

    render 'jsons/features', formats: :json
  end

  def show
    render json: @feature, status: :ok
  end

  def create
    @feature = @project.features.build(feature_param)
    if @feature.save
      render_action_model_success_message(@feature, :create)
    else
      render_action_model_fail_message(@feature, :create)
    end
  end

  def update
    @feature.attributes = feature_param
    if @feature.save
      render_action_model_success_message(@feature, :update)
    else
      render_action_model_fail_message(@feature, :update)
    end
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def feature_param
    params.require(:feature).permit(:title, :point, :status)
  end

  def features_params
    params.require(:features).map { |u| u.permit(:id, :title, :point, :status, :iteration_id) }
  end
end
