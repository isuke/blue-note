class Api::ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
    render json: @projects, status: :ok
  end
end
