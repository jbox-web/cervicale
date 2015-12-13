module BaseController::Devise
  extend ActiveSupport::Concern

  included do
    before_action :configure_permitted_parameters, if: :devise_controller?
  end


  protected


    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:login) { |u| u.permit(:email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:current_password, :password, :password_confirmation) }
      # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation) }
    end

end
