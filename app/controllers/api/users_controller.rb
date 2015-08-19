class Api::UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      render(
        json: {
          id: @user.id,
          message: I18n.t('action.create.success', model: I18n.t('activerecord.models.user')),
        },
        status: :created,
      )
    else
      render(
        json: {
          message: I18n.t('action.create.fail', model: I18n.t('activerecord.models.user')),
          errors: { messages: @user.errors.messages, full_messages: @user.errors.full_messages },
        },
        status: :unprocessable_entity,
      )
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
