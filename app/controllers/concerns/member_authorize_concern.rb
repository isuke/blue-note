module MemberAuthorizeConcern
  extend ActiveSupport::Concern

private

  def member_authorize(project, only: nil)
    member_include_authorize(project)
    member_role_authorize(project, only: only)
  end

  def member_include_authorize(project)
    return if project.users.include? current_user
    respond_to do |format|
      format.html { redirect_to root_path, error: 'unauthorized' }
      format.json { render(json: { message: 'unauthorized', full_message: "Sorry. You can not view this project's page." }, status: :unauthorized) }
    end
  end

  def member_role_authorize(project, only: nil)
    return if only.nil? || only.include?(current_user.role_in(project).to_sym)
    respond_to do |format|
      format.html { redirect_to root_path, error: 'unauthorized' }
      format.json { render(json: { message: 'unauthorized', full_message: "Sorry. You don't have permission of this action." }, status: :unauthorized) }
    end
  end
end
