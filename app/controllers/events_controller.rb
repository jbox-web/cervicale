class EventsController < ApplicationController

  include EasyDCI::Controller
  include BaseController::DCICustom

  set_dci_context 'EventContext'
  self.render_notice_messages = -> (request) { !request.xhr? }

  before_action :find_calendar_owner
  before_action :find_calendar
  before_action :find_event, except: [:index, :new, :create]


  def index
    render json: EventContext.new(self).get_events(@calendar, params).to_json
  end


  def show
    render_modal_box(locals: { event: @event })
  end


  def new
    render_modal_box(locals: { eventable: @calendar, event: @calendar.events.new })
  end


  def create
    set_dci_data(_dci_params_on_create)
    call_dci_context(:create, @calendar, User.current, render_partial: true)
  end


  def edit
    # authorize @event
    render_modal_box(locals: { eventable: @calendar, event: @event })
  rescue Pundit::NotAuthorizedError
    render_403
  end


  def update
    # authorize @event
    set_dci_data(event: [:title, :description, :location, :color, :category_list, :visibility, :start_time, :end_time, :all_day, :frequency, :repeat_until, :update_options, event_attachments_attributes: [:id, :url, :_destroy]])
    call_dci_context(:update, @event, render_partial: true)
  rescue Pundit::NotAuthorizedError
    render_403
  end


  def destroy
    # authorize @event
    call_dci_context(:delete, @event, params, render_partial: true)
  rescue Pundit::NotAuthorizedError
    render_403
  end


  def move
    # authorize @event
    set_dci_data(event: [:minute_delta, :hour_delta, :day_delta, :all_day])
    call_dci_context(:move, @event, render_partial: true)
  end


  def resize
    # authorize @event
    set_dci_data(event: [:minute_delta, :hour_delta, :day_delta, :all_day])
    call_dci_context(:resize, @event, render_partial: true)
  end


  private


    def find_calendar
      find_calendar_by(params[:calendar_id])
    end


    def _dci_params_on_create
      key = params[:event] ? :event : :event_collection
      { key => [:title, :description, :location, :color, :category_list, :visibility, :start_time, :end_time, :all_day, :frequency, :repeat_until, event_attachments_attributes: [:id, :url, :_destroy]] }
    end


    def load_events
      smart_listing_create(:events, @calendar.events.includes([:eventable, :author]).all, partial: 'events/listing', default_sort: { start_time: 'asc' })
    end


    def render_dci_success(template, locals = {}, opts = {})
      load_events if ['create', 'destroy', 'update', 'resize', 'move'].include?(action_name)
      super
    end

end
