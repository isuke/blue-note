module SessionConcern
  extend ActiveSupport::Concern

  included do
    before_action :current_user, :require_login
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  rescue Authlogic::Session::Activation::NotActivatedError => e
    # FIXME: websocket controller don't send these session methods.
    raise e unless self.class == WebsocketRails::DelegationController
    logger.warn e.message
    nil
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  rescue Authlogic::Session::Activation::NotActivatedError => e
    # FIXME: websocket controller don't send these session methods.
    raise e unless self.class == WebsocketRails::DelegationController
    logger.warn e.message
    nil
  end

  def require_login
    return if current_user
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render(json: { message: 'unauthorized' }, status: :unauthorized) }
    end
  end
end
