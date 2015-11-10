class PagesController < ApplicationController
  include MemberAuthorizeConcern

  skip_before_action :require_login, only: [:home]
  before_action      :set_project  , only: [:progress, :project_settings]
  before_action -> { member_authorize @project }, only: [:progress, :project_settings]

  def home
    render layout: 'simple'
  end

  def dashboard
  end

  def progress
  end

  def project_settings
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
