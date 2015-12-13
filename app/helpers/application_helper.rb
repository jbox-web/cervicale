module ApplicationHelper

  def render_calendar_url(calendar, opts = {})
    content_tag(:div, class: 'input-group') do
      text_field_tag("url_calendar_#{calendar.id}", ics_calendar_url(calendar.owner.email, calendar), { class: 'form-control', readonly: 'readonly' }.merge(opts)) +
      render_calendar_zc_button(calendar)
    end
  end


  def render_color(color, opts = {})
    color = color || '#fff'
    content_tag(:span, '', style: "background: #{color}; width: 16px; height: 16px; display: block; margin: 0 auto;")
  end


  def render_calendar_zc_button(calendar)
    content_tag(:span, class: 'input-group-btn') do
      content_tag(:div, zero_clipboard_button_for("url_calendar_#{calendar.id}"), class: 'btn btn-default')
    end
  end


  def render_visibility(event)
    title = Eventable::PRIVACY_OPTIONS[event.visibility.downcase.to_sym]
    icon_name =
      if event.public?
        'fa-users'
      elsif event.private?
        'fa-eye'
      elsif event.confidential?
        'fa-eye-slash'
      end
    icon(icon_name, title: title)
  end

end
