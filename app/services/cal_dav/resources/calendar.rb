module CalDav
  module Resources
    class Calendar < CalDav::Resources::Base

      ALL_PROPERTIES = {
        'DAV:' => %w(
          supported-report-set
        ),
        'urn:ietf:params:xml:ns:caldav' => %w(
          supported-calendar-component-set
        ),
        'http://calendarserver.org/ns/' => %w(
          getctag
        )
      }

      EXPLICIT_PROPERTIES = {}


      def is_self?(slug)
        calendar.slug == slug
      end


      def calendar
        @owner    ||= User.find_by_email(@calendar_owner)
        @calendar ||= current_user.find_calendar_by_owner_and_slug(@owner, @calendar_slug)
      end


      def collection?
        true
      end


      def exist?
        !calendar.nil?
      end


      def display_name
        calendar.title
      end


      def children
        calendar.events.map { |e| child(e.uuid) }
      end


      # name:: Name of child
      # Create a new child with the given name
      # NOTE:: Include trailing '/' if child is collection
      def child(name)
        new_public = public_path.dup
        new_public = new_public + '/' unless new_public[-1,1] == '/'
        new_public = '/' + new_public unless new_public[0,1] == '/'
        new_path = path.dup
        new_path = new_path + '/' unless new_path[-1,1] == '/'
        new_path = '/' + new_path unless new_path[0,1] == '/'
        CalDav::Resources::Event.new("#{new_public}#{name}", "#{new_path}#{name}", request, response, options.merge(user: @user))
      end


      ## Properties follow in alphabetical order
      protected


        prop :description do
          calendar.description
        end


        prop :getcontenttype do
          s = "<getcontenttype>text/calendar</getcontenttype>"
          Nokogiri::XML::DocumentFragment.parse(s)
        end


        prop :getctag do
          s = "<CS:getctag xmlns:CS='http://calendarserver.org/ns/'>#{calendar.updated_at.to_i}</CS:getctag>"
          Nokogiri::XML::DocumentFragment.parse(s)
        end


        prop :getetag do
          s = "<CS:getetag xmlns:CS='http://calendarserver.org/ns/'>#{calendar.updated_at.to_i}</CS:getetag>"
          Nokogiri::XML::DocumentFragment.parse(s)
        end


        prop :getlastmodified do
          calendar.updated_at.httpdate
        end


        prop :supported_calendar_component_set do
          s = "<D:supported-calendar-component-set xmlns:D='DAV:' />"
          Nokogiri::XML::DocumentFragment.parse(s)
        end


        prop :supported_report_set do
          reports = %w(calendar-multiget calendar-query)
          s = "<D:supported-report-set>%s</D:supported-report-set>"

          reports_aggregate = reports.inject('') do |ret, report|
            ret << "<D:report><C:%s xmlns:C='urn:ietf:params:xml:ns:caldav'/></D:report>" % report
          end

          s %= reports_aggregate
          Nokogiri::XML::DocumentFragment.parse(s)
        end


        prop :resourcetype do
          s = '<resourcetype><D:collection /><C:calendar xmlns:C="urn:ietf:params:xml:ns:caldav"/></resourcetype>'
          Nokogiri::XML::DocumentFragment.parse(s)
        end

    end
  end
end
