class RegistrationsController < Devise::RegistrationsController


  protected


    def after_update_path_for(resource)
      my_account_path
    end

end
