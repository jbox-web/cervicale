class EventContext < EasyDCI::Context

  def get_events(object, params = {})
    start_time = Date.parse(params[:start]).to_formatted_s(:db)
    end_time   = Date.parse(params[:end]).to_formatted_s(:db)
    find_events(start_time, end_time, object).map { |event| build_event(event) }.compact
  end


  def create(object, user, params = {})
    if params[:frequency] == 'no_repeat'
      event = object.events.new(params.merge(author: user))
    else
      attach_params = params.delete(:event_attachments_attributes) { {} }
      event = object.event_collections.new(params.merge(author: user))
    end

    if event.save
      create_event_collection(event, params[:uuid], params[:repeat_until], event_attachments_attributes: attach_params) if event.is_a?(EventCollection)
      render_success
    else
      puts event.errors.full_messages
      render_failure(locals: { eventable: object, event: event })
    end
  end


  def update(event, params = {})
    case params[:update_options]
    when 'update_all'
      events = event.event_collection.events
      update_event_collection(event, events, params)
    when 'update_following'
      events = get_following_events(event)
      update_event_collection(event, events, params)
    else
      event.update(params)
    end
    render_success
  end


  def delete(event, params = {})
    case params[:delete_options]
    when 'delete_all'
      event.event_collection.destroy
    when 'delete_following'
      get_following_events(event).map(&:destroy)
    else
      event.destroy
    end
    render_success
  end


  def move(event, params = {})
    event.start_time = make_time_from_delta(event.start_time, params)
    event.end_time   = make_time_from_delta(event.end_time, params)
    event.all_day    = params[:all_day]
    event.save ? render_success : render_failure(locals: { event: event })
  end


  def resize(event, params = {})
    event.end_time = make_time_from_delta(event.end_time, params)
    event.save ? render_success : render_failure(locals: { event: event })
  end


  private


    def find_events(start_time, end_time, scope = nil)
      scope = scope.nil? ? Event : scope.events
      scope.includes([:eventable]).where('
        (start_time >= :start_time and end_time <= :end_time) or
        (start_time >= :start_time and end_time > :end_time and start_time <= :end_time) or
        (start_time <= :start_time and end_time >= :start_time and end_time <= :end_time) or
        (start_time <= :start_time and end_time > :end_time)',
        start_time: start_time, end_time: end_time)
    end


    def get_following_events(event)
      event.event_collection.events.where('start_time >= :start_time', start_time: event.start_time.to_formatted_s(:db)).to_a
    end


    def build_event(event)
      return nil unless caller.policy(event).visible?
      if caller.policy(event).details_visible?
        {
          id:          event.id,
          title:       event.title,
          description: event.description,
          color:       (event.color || ''),
          start:       event.start_time.iso8601,
          end:         event.end_time.iso8601,
          allDay:      event.all_day,
          recurring:   (event.event_collection_id ? true : false),
          path:        caller.polymorphic_path([event.eventable.owner, event.eventable, event])
        }
      else
        {
          id:          event.id,
          color:       (event.color || ''),
          start:       event.start_time.iso8601,
          end:         event.end_time.iso8601,
          allDay:      event.all_day,
          recurring:   (event.event_collection_id ? true : false),
          path:        caller.polymorphic_path([event.eventable.owner, event.eventable, event])
        }
      end
    end


    def create_event_collection(collection, first_uuid, max_end_time, params = {})
      old_start_time   = collection.start_time
      old_end_time     = collection.end_time
      new_uuid         = first_uuid
      new_start_time, new_end_time = old_start_time, old_end_time

      while collection.repetition.send(collection.frequency_period).from_now(old_start_time) <= max_end_time
        opts = {
          uuid:           new_uuid,
          title:          collection.title,
          description:    collection.description,
          location:       collection.location,
          color:          collection.color,
          all_day:        collection.all_day,
          start_time:     new_start_time,
          end_time:       new_end_time,
          user_id:        collection.author.id,
          eventable_id:   collection.eventable_id,
          eventable_type: collection.eventable_type
        }.merge(params)

        collection.events.create(opts)

        new_start_time = old_start_time = collection.repetition.send(collection.frequency_period).from_now(old_start_time)
        new_end_time   = old_end_time   = collection.repetition.send(collection.frequency_period).from_now(old_end_time)
        new_uuid       = nil

        if collection.frequency.downcase == 'monthly' or collection.frequency.downcase == 'yearly'
          begin
            new_start_time = make_date_time_for_create(collection.start_time, old_start_time)
            new_end_time   = make_date_time_for_create(collection.end_time, old_end_time)
          rescue
            new_start_time = new_end_time = nil
          end
        end
      end
    end


    def update_event_collection(event, events, params = {})
      attach_params = params.delete(:event_attachments_attributes) { {} }

      events.each do |e|
        begin
          old_start_time, old_end_time = e.start_time, e.end_time
          e.attributes = params

          if event.event_collection.frequency.downcase == 'monthly' or event.event_collection.frequency.downcase == 'yearly'
            new_start_time = make_date_time_for_update(e.start_time, old_start_time)
            new_end_time   = make_date_time_for_update(e.start_time, old_end_time, e.end_time)
          else
            new_start_time = make_date_time_for_update(e.start_time, old_end_time)
            new_end_time   = make_date_time_for_update(e.end_time, old_end_time)
          end
        rescue
          new_start_time = new_end_time = nil
        end

        if new_start_time && new_end_time
          e.start_time = new_start_time
          e.end_time   = new_end_time
        end

        e.save
      end

      event.event_collection.attributes = params
      event.event_collection.save
    end


    def make_time_from_delta(event_time, params)
      params[:minute_delta].to_i.minutes.from_now((params[:hour_delta].to_i).hours.from_now((params[:day_delta].to_i).days.from_now(event_time)))
    end


    def make_date_time_for_create(original_time, difference_time)
      str = "#{original_time.hour}:#{original_time.min}:#{original_time.sec}, #{original_time.day}-#{difference_time.month}-#{difference_time.year}"
      Time.zone.parse(str)
    end


    def make_date_time_for_update(original_time, difference_time, event_time = nil)
      str = "#{original_time.hour}:#{original_time.min}:#{original_time.sec}, #{event_time.try(:day) || difference_time.day}-#{difference_time.month}-#{difference_time.year}"
      Time.zone.parse(str)
    end

end
