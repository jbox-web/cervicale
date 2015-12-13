module CalDav
  module Controllers
    class Base < DAV4Rack::Controller

      # Flags for to_xml for use with XML debugging/logging.  This will compact everything.
      NO_INDENT_FLAGS = { save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION }

      # Flags for to_xml for use with XML debugging/logging.  This will pretty print things.
      YES_INDENT_FLAGS = { save_with: Nokogiri::XML::Node::SaveOptions::FORMAT | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION, indent: 2 }


      def initialize(request, response, options = {})
        super
        @response['Access-Control-Allow-Origin'] = '*' if Cervicale::Application.config.permissive_cross_domain_policy == true
        @response['Server']                      = Cervicale::Application.config.calendar_long_version
        @response['X-Cervicale-Version']         = Cervicale::Application.config.calendar_version
        @response['DAV']                         = '1, 2, 3, access-control, calendar-access, version-control'
      end


      private


        # Takes a block, gives it an xml builder with a DAV:error root element, and
        # will render the XML body and set an HTTP error code.  The HTTP status is
        # 403-Forbidden by default as per WebDAV's suggestions, alternatively, 409
        # a.k.a. Conflict is suggested for errors that are transient.  Any HTTPStatus
        # class will work.  Because this triggers an exception, it won't return.
        #
        def xml_error(http_error_code=Forbidden, &block)
          render_xml(:error) do |xml|
            block.yield(xml)
          end
          raise http_error_code
        end


        def xpath_element(name, ns_uri = :dav)
          case ns_uri
          when :dav
            ns_uri = 'DAV:'
          when :caldav
            ns_uri = 'urn:ietf:params:xml:ns:caldav'
          end
          "*[local-name()='#{name}' and namespace-uri()='#{ns_uri}']"
        end


        def log_request_headers
          Rails.logger.info 'Dumping request headers :'
          request.env.select {|k,v| k.start_with? 'HTTP_'}.each do |k,v|
            Rails.logger.info "#{k.sub(/^HTTP_/, '').titleize.gsub(' ', '-')}: #{v}"
          end
          Rails.logger.info '---'
        end


        def log_request
          Rails.logger.info "*** REQUEST BEGIN"
          Rails.logger.info request.body.read.inspect
          Rails.logger.info request_document.to_xml(YES_INDENT_FLAGS)
          Rails.logger.info "*** REQUEST END"
        end


        def log_response
          Rails.logger.info "*** RESPONSE BEGIN"
          x = Nokogiri::XML(response.body) do |config|
            config.default_xml.noblanks
          end
          Rails.logger.info x.to_xml(YES_INDENT_FLAGS)
          Rails.logger.info "*** RESPONSE END"
        end

    end
  end
end
