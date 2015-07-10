class Availability < ActiveRecord::Base
  belongs_to :user
  has_many :bookings

  before_save :set_defaults

  # Validate associations
  validates :user, presence: true

  # Validate attributes
  validates :start_at,
            :end_at,
            :beginning_of_business_day,
            :end_of_business_day,
            :duration,
            :cancellation_period,
            :late_cancellation_fee,
            presence: true

  validate :beginning_of_business_day_less_than_end_of_business_day, if: :required_attrs?
  validate :start_at_less_than_end_at,                               if: :required_attrs?

  private

  def beginning_of_business_day_less_than_end_of_business_day
    if beginning_of_business_day >= end_of_business_day
      errors.add(:beginning_of_business_day, "should be less than end of business")
    end
  end

  def start_at_less_than_end_at
    if start_at >= end_at
      errors.add(:start_at, "should be less than end at")
    end
  end

  def required_attrs?
    start_at.present? &&
    end_at.present? &&
    beginning_of_business_day.present? &&
    end_of_business_day.present? &&
    duration.present?
  end

  def set_defaults
    self.recurring_calendar_days ||= []
    self.size_of_group ||= 1
    self.priority ||= 1
  end
end
