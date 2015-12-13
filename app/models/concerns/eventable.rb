module Eventable
  extend ActiveSupport::Concern

  REPEAT_OPTIONS = {
    no_repeat:  Event.human_attribute_name('no_repeat'),
    daily:      Event.human_attribute_name('repeat_days'),
    weekly:     Event.human_attribute_name('repeat_weeks'),
    monthly:    Event.human_attribute_name('repeat_months'),
    yearly:     Event.human_attribute_name('repeat_years')
  }

  UPDATE_OPTIONS = {
    update:           Event.human_attribute_name('update'),
    update_all:       Event.human_attribute_name('update_all'),
    update_following: Event.human_attribute_name('update_following')
  }

  PRIVACY_OPTIONS = {
    public:       Event.human_attribute_name('public'),
    private:      Event.human_attribute_name('private'),
    confidential: Event.human_attribute_name('confidential')
  }

  included do
    attr_accessor :update_options

    # Relations
    belongs_to :eventable, polymorphic: true, touch: true
    belongs_to :author,    class_name: 'User', foreign_key: 'user_id'

    # Validations
    validates :start_time, presence: true
    validates :end_time,   presence: true

    class << self

      def available_frequency_periods
        periods = []
        Eventable::REPEAT_OPTIONS.each do |k, v|
          periods << [v, k]
        end
        periods
      end


      def available_update_options
        options = []
        Eventable::UPDATE_OPTIONS.each do |k, v|
          options << [v, k]
        end
        options
      end


      def available_visibility_options
        options = []
        Eventable::PRIVACY_OPTIONS.each do |k, v|
          options << [v, k.to_s.upcase]
        end
        options
      end

    end
  end


  private


    def validate_timings
      if (start_time >= end_time) && !all_day
        errors.add(:base, :invalid)
      end
    end

end
