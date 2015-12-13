class User < ActiveRecord::Base

  # Devise stuff
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :registerable

  # Users can create tags
  acts_as_tagger

  # Relations
  has_many :calendars, foreign_key: 'owner_id'
  has_many :calendars_users
  has_many :calendars_memberships, through: :calendars_users, source: 'calendar'

  # Validations
  validates :first_name, presence: true
  validates :last_name,  presence: true

  # Callbacks
  before_validation :ensure_authentication_token

  # Scopes
  scope :order_by_full_name, -> { order(first_name: :asc).order(last_name: :asc) }

  scope :admin,        -> { where(admin: true) }
  scope :non_admin,    -> { where(admin: false) }
  scope :active,       -> { where(enabled: true) }
  scope :locked,       -> { where(enabled: false) }

  class << self

    def current=(user)
      RequestStore.store[:current_user] = user
    end

    def current
      RequestStore.store[:current_user] ||= User.anonymous
    end

    # Returns the anonymous user.
    def anonymous
      AnonymousUser.new(first_name: 'Anonymous', last_name: '', email: '')
    end

    def available_for_membership
      User.active.all - [User.current]
    end

  end


  def to_s
    full_name
  end


  def full_name
    "#{first_name} #{last_name}"
  end


  def logged?
    true
  end


  def anonymous?
    !logged?
  end


  def last_connection
    last_sign_in_at ? I18n.l(last_sign_in_at) : User.human_attribute_name('never_connected')
  end


  def first_admin?
    return false if id.nil?
    id == 1
  end


  def current_theme
    return 'default' if theme.nil? || theme.empty?
    theme
  end


  def find_calendar_by_owner_and_slug(owner, slug)
    calendar = calendars.find_by_owner_id_and_slug(owner.id, slug)
    if calendar
      calendar
    else
      calendars_memberships.find_by_user_id(owner.id).select { |c| c.slug == slug }.first
    end
  end


  private


    def ensure_authentication_token
      self.authentication_token = generate_authentication_token if authentication_token.blank?
    end


    def generate_authentication_token
      loop do
        token = EasyAPP::Utils::Crypto.generate_secret(42)
        break token unless User.where(authentication_token: token).first
      end
    end
end
