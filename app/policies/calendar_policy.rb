class CalendarPolicy

  attr_reader :user, :calendar

  def initialize(user, calendar)
    @user     = user
    @calendar = calendar
  end


  def show?
    calendar_owner? || calendar_member?
  end


  def edit?
    calendar_owner?
  end


  def update?
    calendar_owner?
  end


  def destroy?
    calendar_owner?
  end


  def add_event?
    calendar.permissions_for(user) == 'RW'
  end


  private


    def calendar_owner?
      calendar.owner == user
    end


    def calendar_member?
      calendar.members.include?(user)
    end

end
