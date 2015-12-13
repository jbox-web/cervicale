module BaseController::Helpers
  extend ActiveSupport::Concern

  include SmartListing::Helper::ControllerExtensions

  included do
    helper SmartListing::Helper
  end

end
