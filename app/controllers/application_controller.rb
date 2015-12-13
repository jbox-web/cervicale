class ApplicationController < ActionController::Base
  include Pundit
  include EasyAPP::Base

  include BaseController::Devise
  include BaseController::UserSettings
  include BaseController::Authorizations
  include BaseController::Helpers


  private


    def render_pundit_error
      render_403
    end


    def find_calendar_owner
      find_calendar_owner_by(params[:user_id])
    end


    def find_calendar
      find_calendar_by(params[:id])
    end


    def find_event
      find_event_by(params[:id])
    end


    def find_calendar_owner_by(param)
      @user = User.find_by_id(param)
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def find_calendar_by(param)
      @calendar = @user.calendars.find_by_slug(param)
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def find_event_by(param)
      @event = @calendar.events.find_by_id(param)
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end

end
