class Api::ProjectsController < Api::ApiController
  def index
    @projects = current_user.projects.order(:id)
    render json: @projects, status: :ok
  end

  def create
    @project = Project.new(project_param)
    @project.save!
    current_user.join!(@project, role: :admin)

    render_action_model_success_message(@project, :create)
  rescue
    render_action_model_fail_message(@project, :create)
  end

private

  def project_param
    params.require(:project).permit(:name)
  end
end
