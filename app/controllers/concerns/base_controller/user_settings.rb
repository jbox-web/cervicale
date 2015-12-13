module BaseController::UserSettings
  extend ActiveSupport::Concern

  included do
    before_action :setup_user
    before_action :setup_locale
    theme         :theme_resolver, prepend: false

    # Set TimeZone for current user
    # Must be in a around_action : Time.zone is NOT request local
    # http://railscasts.com/episodes/106-time-zones-revised?view=comments#comment_162005
    around_action :set_time_zone
  end


  def setup_user
    User.current = current_user
  end


  def setup_locale
    I18n.locale = User.current.language || I18n.default_locale
  end


  def set_time_zone(&block)
    Time.use_zone(User.current.time_zone, &block)
  end


  def reload_user_locales
    User.current.reload
    setup_locale
  end


  def theme_resolver
    User.current.current_theme
  end

end
