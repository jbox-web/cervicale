class Admin::DefaultController < ApplicationController

  before_action :require_admin
  before_action :set_sidebar_items


  private


    def set_sidebar_items
      EasyAPP::BaseNavigation.sidebar_menu_top_content = [:admin_menu]
    end

end
