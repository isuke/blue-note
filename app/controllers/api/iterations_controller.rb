class Api::IterationsController < Api::ApiController
  include MemberAuthorizeConcern

  before_action :set_project, only: [:index]
  before_action -> { member_authorize @project }, only: [:index]

  def index
    @iterations = @project.iterations.order(:id)
    render json: @iterations, status: :ok
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
