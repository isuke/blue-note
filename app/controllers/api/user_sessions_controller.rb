class Api::UserSessionsController < Api::ApiController
  skip_before_action :require_login, only: [:create]

  def create
    @user_session = UserSession.new(user_session_params)
    if @user_session.save
      render(json: { message: 'login successed' }, status: :ok)
    else
      render(json: { message: 'login faild' }, status: :unprocessable_entity)
    end
  end

  def destroy
    current_user_session.destroy
    render(json: { message: 'logout successed' }, status: :ok)
  rescue
    render(json: { message: 'logout faild' }, status: :bad_request)
  end

private

  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end
end
