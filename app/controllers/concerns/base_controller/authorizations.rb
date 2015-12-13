module BaseController::Authorizations
  extend ActiveSupport::Concern

  included do
    before_action :require_login
  end


  def require_login
    authenticate_user!
  end


  def require_admin
    return unless require_login
    render_403 if !User.current.admin?
  end


  def deny_access
    User.current.logged? ? render_403 : require_login
  end

end
