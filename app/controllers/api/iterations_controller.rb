class Api::IterationsController < Api::ApiController
  before_action :set_project, only: [:index]

  def index
    @iterations = @project.iterations
    render json: @iterations, status: :ok
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
