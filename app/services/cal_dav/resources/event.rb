require 'icalendar/tzinfo'

module CalDav
  module Resources
    class Event < CalDav::Resources::Base

      attr_reader :event

      ALL_PROPERTIES      = {
        'urn:ietf:params:xml:ns:caldav' => %w(calendar-data)
      }

      EXPLICIT_PROPERTIES = {}


      # An *EventResource* is not a collection
      def collection?
        false
      end


      def event
        @event ||= find_event_by_uid(@event_uid)
      end


      def calendar
        parent.calendar
      end


      def parent
        unless @path.to_s.empty?
          CalDav::Resources::Calendar.new(
            File.split(@public_path).first,
            File.split(@path).first,
            @request,
            @response,
            @options.merge(user: @user)
          )
        end
      end


      def put(request, response)
        i_calendar = Icalendar.parse(request.body).first
        i_calendar.events.each do |i_event|
          event = find_event_by_uid(i_event.uid)
          event.nil? ? create_event(i_event) : update_event(event, i_event)
        end
        Created
      end


      def delete
        if event.from_collection?
          event.event_collection.destroy
        else
          event.destroy
        end
      end


      protected


        prop :calendar_data= do
          raise Forbidden
        end


        prop :calendar_data, args: true do
          s = "<C:calendar-data xmlns:C='urn:ietf:params:xml:ns:caldav'><![CDATA[#{event.to_ical(current_user.time_zone)}]]></C:calendar-data>"
          Nokogiri::XML::DocumentFragment.parse(s)
        end


        prop :getcontenttype do
          s = "<getcontenttype>text/calendar</getcontenttype>"
          Nokogiri::XML::DocumentFragment.parse(s)
        end


        prop :getetag do
          s = "<CS:getetag xmlns:CS='http://calendarserver.org/ns/'>#{event.updated_at.to_i}</CS:getetag>"
          Nokogiri::XML::DocumentFragment.parse(s)
        end


        prop :resourcetype do
          s = '<resourcetype></resourcetype>'
          Nokogiri::XML::DocumentFragment.parse(s)
        end


      private


          def find_event_by_uid(uid)
            calendar.events.find_by_uuid(uid.to_s)
          end


          def create_event(i_event)
            opts = {}
            opts[:uuid]          = i_event.uid
            opts[:title]         = i_event.summary
            opts[:description]   = i_event.description
            opts[:location]      = i_event.location
            opts[:category_list] = i_event.categories
            opts[:start_time]    = i_event.dtstart.utc.to_s
            opts[:end_time]      = i_event.dtend.utc.to_s
            opts[:created_at]    = i_event.created
            opts[:updated_at]    = i_event.last_modified
            opts[:visibility]    = i_event.ip_class
            opts[:frequency]     = i_event.rrule.first.nil? ? 'no_repeat' : i_event.rrule.first.frequency
            opts[:repeat_until]  = i_event.rrule.first.nil? ? '' : i_event.rrule.first.until

            EventContext.new(self).create(calendar, current_user, opts)
          end


          def update_event(event, i_event)
            # puts YAML::dump(i_event)

            opts = {}
            opts[:title]          = i_event.summary
            opts[:description]    = i_event.description
            opts[:location]       = i_event.location
            opts[:category_list]  = i_event.categories
            opts[:visibility]     = i_event.ip_class
            opts[:start_time]     = i_event.dtstart.to_formatted_s(:db) unless i_event.dtstart.nil?
            opts[:end_time]       = i_event.dtend.to_formatted_s(:db) unless i_event.dtend.nil?

            if i_event.recurrence_id
              opts[:update_options] = 'update'
            elsif i_event.rdate.any? && i_event.recurrence_id.nil?
              opts[:update_options] = 'update_all'
            end

            EventContext.new(self).update(event, opts)
          end

    end
  end
end
