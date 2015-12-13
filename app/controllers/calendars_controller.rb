class CalendarsController < ApplicationController

  include EasyDCI::Controller
  include BaseController::DCICustom

  set_dci_context 'CalendarContext'

  before_action :find_calendar_owner
  before_action :find_calendar, except: [:index, :new, :create]
  before_action :add_breadcrumbs

  after_action  :verify_authorized, except: [:index, :create]

  rescue_from Pundit::NotAuthorizedError, with: :render_pundit_error


  def index
    smart_listing_create(:my_calendars, @user.calendars.includes([:owner, :members]).all, partial: 'calendars/my_calendars', default_sort: { name: 'asc' })
    smart_listing_create(:my_memberships, @user.calendars_memberships.all, partial: 'calendars/my_memberships', default_sort: { name: 'asc' })
  end


  def show
    authorize @calendar
    smart_listing_create(:events, @calendar.events.includes([:eventable, :author]).all, partial: 'events/listing', default_sort: { start_time: 'asc' })
  end


  def new
    authorize @user, :create_calendar?
    render_modal_box(locals: { calendar: @user.calendars.new })
  end


  def create
    set_dci_data(calendar: [:name, :description, :color, calendars_users_attributes: [:id, :user_id, :permissions, :_destroy]])
    call_dci_context(:create, @user)
  end


  def edit
    authorize @calendar
    render_modal_box(locals: { calendar: @calendar })
  end


  def update
    authorize @calendar
    set_dci_data(calendar: [:name, :description, :color, calendars_users_attributes: [:id, :user_id, :permissions, :_destroy]])
    call_dci_context(:update, @calendar)
  end


  def destroy
    authorize @calendar
    call_dci_context(:delete, @calendar)
  end


  private


    def default_redirect_url
      user_calendars_path(@user)
    end


    def add_breadcrumbs(action: action_name)
      add_breadcrumb @user.to_s, 'fa-calendar', default_redirect_url

      case action
      when 'show'
        add_crumb @calendar.name, '#'
      when 'new', 'create'
        add_crumb t('.title'), '#'
      when 'edit', 'update'
        add_crumb @calendar.name, user_calendar_path(@user, @calendar)
        add_crumb t('button.edit'), '#'
      else
        ''
      end
    end

end
