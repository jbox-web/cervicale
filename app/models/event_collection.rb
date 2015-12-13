class EventCollection < ActiveRecord::Base

  include Eventable

  attr_accessor :uuid, :title, :description, :location, :color, :visibility, :category_list

  # Relations
  has_many :events, dependent: :destroy

  # Validations
  validates :frequency,    presence: true
  validates :repeat_until, presence: true

  # Callbacks
  before_validation :upcase_fields


  def repetition
    1
  end


  def frequency_period
    case frequency
    when 'DAILY'
      'days'
    when 'WEEKLY'
      'weeks'
    when 'MONTHLY'
      'months'
    when 'YEARLY'
      'years'
    end
  end


  private


    def upcase_fields
      self.frequency = frequency.upcase unless frequency.nil?
    end

end
