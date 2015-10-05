class Api::FeaturesController < ApplicationController
  before_action :set_project, only: [:index, :create]
  before_action :set_feature, only: [:show, :update]

  def index
    @features = @project.features.order(:status, updated_at: :desc)
    render json: @features, status: :ok
  end

  def show
    render json: @feature, status: :ok
  end

  def create
    @feature = @project.features.build(feature_param)
    if @feature.save
      render(
        json: {
          id: @feature.id,
          message: I18n.t('action.create.success', model: I18n.t('activerecord.models.feature')),
        },
        status: :created,
      )
    else
      render(
        json: {
          message: I18n.t('action.create.fail', model: I18n.t('activerecord.models.feature')),
          errors: { messages: @feature.errors.messages, full_messages: @feature.errors.full_messages },
        },
        status: :unprocessable_entity,
      )
    end
  end

  def update
    @feature.attributes = feature_param
    if @feature.save
      render(
        json: {
          id: @feature.id,
          message: I18n.t('action.update.success', model: I18n.t('activerecord.models.feature')),
        },
        status: :created,
      )
    else
      render(
        json: {
          message: I18n.t('action.update.fail', model: I18n.t('activerecord.models.feature')),
          errors: { messages: @feature.errors.messages, full_messages: @feature.errors.full_messages },
        },
        status: :unprocessable_entity,
      )
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
    params.require(:feature).permit(:title, :priority, :point, :status)
  end
end
