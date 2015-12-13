class EventPolicy

  attr_reader :user, :event

  def initialize(user, event)
    @user  = user
    @event = event
  end


  def visible?
    return true if event.author == user
    return true if event.public? || event.confidential?
    return false
  end


  def details_visible?
    return true if event.author == user || event.public?
    return false
  end

end
