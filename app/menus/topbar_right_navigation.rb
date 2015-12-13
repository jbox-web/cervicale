class TopbarRightNavigation < EasyAPP::BaseNavigation

  def nav_menu
    User.current.logged? ? menu_for_logged_user : menu_for_anonymous_user
  end


  def menu_for_logged_user
    topbar_right_menu do |menu|
      menu.item :admin, label_with_icon('', 'fa-gear'), admin_root_path, html: { title: t('text.administration') }, if: -> { User.current.admin? }
      menu.item :calendars, label_with_icon(t('text.my_calendars'), 'fa-calendar'), user_calendars_path(User.current)
      menu.item :logged, label_with_icon('', 'fa-user'), my_account_path, highlights_on: %r(/my), link_html: { data: { toggle: 'dropdown' } }, class: 'dropdown' do |sub_menu|
        sub_menu.auto_highlight = false
        sub_menu.dom_class = dropdown_menu_class
        sub_menu.item :me, User.current.to_s, '#', html: { class: 'dropdown-header', role: :presentation }
        sub_menu.item :divider, '', '', html: { class: :divider, role: :presentation }
        sub_menu.item :my_account, label_with_icon(t('text.my_account'), 'fa-user', bigger: false, fixed: true), my_account_path, highlights_on: %r(/my)
        sub_menu.item :divider, '', '', html: { class: :divider, role: :presentation }
        sub_menu.item :logout,  label_with_icon(t('text.logout'), 'fa-sign-out', bigger: false, fixed: true), destroy_user_session_path, method: :delete
      end
    end
  end


  def menu_for_anonymous_user
    topbar_right_menu do |menu|
      menu.item :signup, t('text.signup'), new_user_registration_path
      menu.item :login, t('text.login'), new_user_session_path
    end
  end


  def admin_section?
    controller.class.name.split("::").first == 'Admin'
  end


  def profile_section?
    %w(MyController RegistrationsController WelcomeController DashboardController).include?(controller.class.name)
  end

end
