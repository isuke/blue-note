module FeaturesControllerEachModelsUpdate
  extend ActiveSupport::Concern

  def update_priority
    old_priority = @feature.priority
    new_priority = params[:insert_at].try(:to_i)
    if new_priority.nil?
      update_priority_remove_from_list(old_priority)
    else
      update_priority_insert_at_list(old_priority, new_priority)
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
      status: :created,
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

  def update_priority_remove_from_list(old_priority)
    if @feature.remove_from_list
      updated_ids = @feature.project.features.where('priority >= ?', old_priority).pluck(:id)
      updated_ids << @feature.id
      render(
        json: { ids: updated_ids, message: I18n.t('action.update.success', model: I18n.t('activerecord.models.feature')) },
        status: :created,
      )
    else
      render_action_model_fail_message(@feature, :update)
    end
  end

  def update_priority_insert_at_list(old_priority, new_priority)
    if @feature.insert_at(new_priority)
      condition = (old_priority.nil? || old_priority > new_priority) ? 'priority >= ?' : 'priority <= ?'
      updated_ids = @feature.project.features.where(condition, new_priority).pluck(:id)
      render(
        json: { ids: updated_ids, message: I18n.t('action.update.success', model: I18n.t('activerecord.models.feature')) },
        status: :created,
      )
    else
      render_action_model_fail_message(@feature, :update)
    end
  end
end
