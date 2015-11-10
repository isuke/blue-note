class Api::MembersController < Api::ApiController
  include MemberAuthorizeConcern

  before_action :set_project, only: [:index, :create]
  before_action -> { member_authorize @project                 }, only: [:index]
  before_action -> { member_authorize @project, only: [:admin] }, only: [:create]

  def index
    @members = @project.members.includes(:user)
    render 'jsons/members', formats: :json, handlers: :jbuilder
  end

  def create
    user = User.find_by!(email: member_param[:email])
    @member = user.member_build(@project, role: member_param[:role])

    if @member.save
      render_action_model_success_message(@member, :create)
    else
      render_action_model_fail_message(@member, :create)
    end
  rescue => e
    render(
      json: {
        message: I18n.t('action.create.fail', model: I18n.t('activerecord.models.member')),
        full_message: e.message,
      },
      status: :bad_request,
    )
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def member_param
    params.require(:member).permit(:email, :role)
  end
end
