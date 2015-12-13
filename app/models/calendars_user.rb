class CalendarsUser < ActiveRecord::Base

  # Relations
  belongs_to :calendar
  belongs_to :user

  # Validations
  validates :calendar_id, presence: true
  validates :user_id,     presence: true
  validates :permissions, presence: true, inclusion: { in: Calendar::CALENDAR_PERMISSIONS }

end
