class Api::ProjectsController < Api::ApiController
  def index
    @projects = current_user.projects
    render json: @projects, status: :ok
  end
end
