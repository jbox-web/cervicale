class Event < ActiveRecord::Base

  include Eventable

  attr_accessor :frequency, :repeat_until

  # Events can have tags
  acts_as_taggable_on :categories

  # Relations
  belongs_to :event_collection
  has_many   :event_attachments, dependent: :destroy

  # Validations
  validates :uuid, presence: true

  # Callbacks
  before_validation :ensure_uuid
  before_validation :upcase_fields

  # Attributes
  accepts_nested_attributes_for :event_attachments, allow_destroy: true


  def to_s
    title
  end


  def title
    _title = read_attribute(:title)
    if _title.nil?
      ''
    elsif _title.empty?
      Event.human_attribute_name('empty_title')
    else
      _title
    end
  end


  def created_by
    "#{Event.human_attribute_name('created_at')} #{I18n.l(created_at)} #{I18n.t('text.by')}"
  end


  def to_ical(time_zone)
    cal = Icalendar::Calendar.new
    cal.timezone.tzid = time_zone
    cal.add_event(ical_event)
    cal.to_ical
  end


  def from_collection?
    !event_collection.nil?
  end


  def first_of_collection?
    event_collection.events.order(start_time: 'asc').first == self
  end


  def ical_event
    ev = Icalendar::Event.new
    ev.uid         = uuid
    ev.summary     = title
    ev.description = description
    ev.location    = location
    ev.categories  = category_list
    ev.ip_class    = visibility

    # ev.sequence    = (all_day? ? 1 : 0)
    # ev.transp      = (all_day? ? 'TRANSPARENT' : '')

    if from_collection?
      if first_of_collection?
        ev.rdate   = event_collection.events.map(&:start_time)
        ev.dtstart = start_time
        ev.dtend   = end_time
      end
    else
      ev.dtstart = start_time
      ev.dtend   = end_time
    end

    event_attachments.each do |attach|
      ev.append_attach Icalendar::Values::Uri.new(attach.url)
    end
    ev
  end


  def public?
    visibility == 'PUBLIC'
  end


  def private?
    visibility == 'PRIVATE'
  end


  def confidential?
    visibility == 'CONFIDENTIAL'
  end


  private


    def upcase_fields
      self.visibility = visibility.upcase unless visibility.nil?
    end


    def ensure_uuid
      self.uuid = generate_uuid if uuid.blank?
    end


    def generate_uuid
      loop do
        uid = SecureRandom.uuid
        break uid unless Event.where(uuid: uid).first
      end
    end

end
