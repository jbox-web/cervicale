require 'icalendar'

class IcsExporter

  attr_reader :calendar


  def initialize(calendar)
    @calendar = calendar
  end


  def export!
    cal = Icalendar::Calendar.new
    cal.publish
    calendar.events.each { |event| cal.add_event(create_ics_event(event)) }
    cal.to_ical
  end


  def create_ics_event(event)
    ev = Icalendar::Event.new
    ev.dtstart     = event.start_time
    ev.dtend       = event.end_time
    ev.summary     = event.title
    ev.description = event.description
    ev.uid         = "id:jbox-calendar:calendar:#{calendar.id}:event:#{event.id}@calendar.jbox-web.fr"
    ev
  end

end
