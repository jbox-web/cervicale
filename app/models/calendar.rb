class Calendar < ActiveRecord::Base

  CALENDAR_PERMISSIONS = %w(R RW)

  # Relations
  belongs_to :owner, class_name: 'User'
  has_many   :calendars_users
  has_many   :members, through: :calendars_users, source: 'user'

  has_many :events, as: :eventable, dependent: :destroy
  has_many :event_collections, as: :eventable, dependent: :destroy

  # Validations
  validates :owner_id, presence: true
  validates :name,     presence: true, uniqueness: { scope: :owner_id}
  validates :slug,     presence: true, uniqueness: { scope: :owner_id}

  # Callbacks
  before_validation :generate_slug

  # Attributes
  accepts_nested_attributes_for :calendars_users, allow_destroy: true

  class << self

    def available_permissions
      CALENDAR_PERMISSIONS.map{ |p| [p, p] }
    end

  end


  def to_s
    name
  end


  def to_param
    slug
  end


  def permissions_for(user)
    return 'RW' if user == owner
    calendars_users.where(user_id: user.id, calendar_id: self.id).first.permissions
  end


  private


    def generate_slug
      self.slug ||= name.parameterize
    end

end
