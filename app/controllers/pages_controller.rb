class PagesController < ApplicationController
  before_action :set_project, only: [:progress]

  def home
    render layout: 'simple'
  end

  def progress
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
