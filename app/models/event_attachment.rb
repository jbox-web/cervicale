class EventAttachment < ActiveRecord::Base

  # Relations
  belongs_to :event

  # Validations
  validates :url, presence: true

end
