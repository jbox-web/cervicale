class AnonymousUser < User

  # Overrides a few properties
  def logged?
    false
  end


  def admin?
    false
  end


  def name(*args)
    I18n.t('label.user.anonymous')
  end


  def email
    nil
  end


  def time_zone
    nil
  end


  # Anonymous user can not be destroyed
  def destroy
    false
  end


  def language
    I18n.default_locale
  end


  def current_theme
    'default'
  end

end
