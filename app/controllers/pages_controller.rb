class PagesController < ApplicationController
  before_action :set_project

  def progress
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

end
