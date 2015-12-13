module BaseController::DCICustom
  extend ActiveSupport::Concern

  def current_layout
    User.current.current_theme
  end

end
