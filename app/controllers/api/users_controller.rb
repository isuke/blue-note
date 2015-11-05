class Api::UsersController < Api::ApiController
  skip_before_action :require_login, only: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      render_action_model_success_message(@user, :create)
    else
      render_action_model_fail_message(@user, :create)
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
