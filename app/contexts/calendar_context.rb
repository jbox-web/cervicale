class CalendarContext < EasyDCI::Context

  def create(user, params = {})
    members = params.delete(:calendars_users_attributes) { {} }
    calendar = Calendar.new(params.merge(owner_id: user.id))
    if calendar.save
      calendar.update(calendars_users_attributes: members)
      render_success
    else
      render_failure(locals: { calendar: calendar })
    end
  end


  def update(calendar, params = {})
    if calendar.update(params)
      render_success
    else
      render_failure(locals: { calendar: calendar })
    end
  end


  def delete(calendar)
    calendar.destroy ? render_success : render_failure(locals: { calendar: calendar })
  end

end
