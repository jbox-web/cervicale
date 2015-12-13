module CalDav
  module Controllers
    class Calendar < CalDav::Controllers::Base

      def report
        return NotFound unless resource.exist?
        return Forbidden unless resource.collection?

        if request_document.nil? or request_document.root.nil?
          xml_error(BadRequest) do |err|
            err.send :'empty-request'
          end
        end

        begin
          case request_document.root.name
          when 'calendar-multiget'
            calendar_multiget
          else
            xml_error do |err|
              err.send :'supported-report'
            end
          end
        ensure
          # log_response
        end
      end


      protected


        def calendar_multiget
          query = "/#{xpath_element('calendar-multiget', :caldav)}/#{xpath_element('href')}"

          hrefs = request_document.xpath(query).collect { |n| n.text }.compact

          if hrefs.empty?
            xml_error(BadRequest) do |err|
              err.send :'href-missing'
            end
          end

          multistatus do |xml|
            hrefs.each do |_href|
              xml.response do
                xml.href _href
                path = File.split(URI.parse(_href).path).last

                cur_resource = resource.is_self?(_href) ? resource : resource.child(path)

                if cur_resource.exist?
                  propstats(xml, get_properties(cur_resource, get_request_props_hash('calendar-multiget', request_document)))
                else
                  xml.status "#{http_version} #{NotFound.status_line}"
                end
              end
            end
          end
        end


        def get_request_props_hash(root_element, request_document)
          query = "/#{xpath_element(root_element, :caldav)}/#{xpath_element('prop')}"
          request_document.xpath(query).children.find_all { |n| n.element? }.map { |n| to_element_hash(n) }
        end

    end
  end
end
