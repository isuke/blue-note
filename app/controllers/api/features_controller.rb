class Api::FeaturesController < ApplicationController
  before_action :set_project, only: [:index, :create, :update_all, :destroy_all]
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

  def update_all
    updated_ids = []
    ActiveRecord::Base.transaction do
      features_params.each do |feature_param|
        feature = @project.features.find(feature_param[:id])
        feature.attributes = feature_param
        feature.save!
        updated_ids << feature.id
      end
    end

    render(
      json: { ids: updated_ids, message: I18n.t('action.update.success', model: I18n.t('activerecord.models.feature')) },
      status: :ok,
    )
  rescue => e
    render(
      json: { message: I18n.t('action.update.fail', model: I18n.t('activerecord.models.feature')), full_message: e.message },
      status: :bad_request,
    )
  end

  def destroy_all
    @project.features.where(id: params[:ids]).destroy_all

    render(
      json: {
        ids: params[:ids],
        message: I18n.t('action.destroy.success', model: I18n.t('activerecord.models.feature')),
      },
      status: :ok,
    )
  rescue => e
    render(
      json: {
        message: I18n.t('action.destroy.fail', model: I18n.t('activerecord.models.feature')),
        full_message: e.message,
      },
      status: :bad_request,
    )
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

  def features_params
    params.require(:features).map { |u| u.permit(:id, :title, :priority, :point, :status) }
  end
end
