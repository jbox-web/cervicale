class AdminMenuNavigation < EasyAPP::BaseNavigation

  def nav_menu
    sidebar_menu do |menu|
      menu.item :users,     label_with_icon(get_model_name_for('User'), 'fa-users', fixed: true, bigger: false), admin_users_path
      menu.item :settings,  label_with_icon(t('text.settings'), 'fa-gear', fixed: true, bigger: false), admin_settings_path
    end
  end


  private


    def navmenu_options
      { renderer: :metis, expand_all: true, remove_navigation_class: true, skip_if_empty: true }
    end

end
