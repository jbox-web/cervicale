module CalDav
  module Controllers
    class Principal < CalDav::Controllers::Base

      def options
        @response['Allow'] = %w(OPTIONS HEAD GET PUT POST DELETE PROPFIND PROPPATCH MKCOL COPY MOVE LOCK UNLOCK ACL MKCALENDAR REPORT TRACE).join(',')
        @response['Content-Length'] = 0
        OK
      end

    end
  end
end
