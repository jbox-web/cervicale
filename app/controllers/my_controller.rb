class MyController < ApplicationController

  include EasyDCI::Controller
  include BaseController::DCICustom

  set_dci_context 'AccountContext'

  before_action :set_user


  def account
    if request.patch?
      set_dci_data({ user: [:first_name, :last_name, :email, :phone_number, :cell_phone_number, :language, :time_zone, :theme] })
      call_dci_context(:update, @user) do
        reload_user_locales
      end
    end
  end

  alias_method :default_redirect_url, :my_account_path


  private


    def set_user
      @user = User.current
    end

end
