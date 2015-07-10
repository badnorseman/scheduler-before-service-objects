class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :coach, class: User
  belongs_to :availability

  before_validation :set_end_at
  before_save :auto_confirm

  default_scope { where("cancelled_at IS NULL") }
  scope :active, -> { where("start_at > ?", Time.zone.now) }

  # Validate associations
  validates :user, :coach, :availability, presence: true

  # Validate attributes
  validates :start_at, :end_at, presence: true
  validate :start_at_less_than_end_at,            if: :required_attrs?
  validate :duration_equal_availability_duration, if: :required_attrs?
  validate :timeshift_is_valid,                   if: [:required_attrs?, :start_at_changed?]
  validate :time_is_available,                    if: [:required_attrs?, :start_at_changed?]

  private

  def start_at_less_than_end_at
    if start_at >= end_at
      errors.add(:start_at, "should be less than end at")
    end
  end

  def duration_equal_availability_duration
    if duration != availability.duration
      errors.add(:start_at, "hasn't valid duration")
    end
  end

  def timeshift_is_valid
    if timeshift % availability.duration != 0
      errors.add(:start_at, "hasn't valid timeshift")
    end
  end

  def time_is_available
    if !coach.bookable?(start_at, end_at)
      errors.add(:start_at, "isn't available")
    end
  end

  def timeshift
    (availability.beginning_of_business_day.seconds_since_midnight - start_at.seconds_since_midnight) / 60
  end

  def duration
    (end_at - start_at) / 1.minute
  end

  def required_attrs?
    start_at.present? &&
    end_at.present? &&
    availability.present? &&
    coach.present?
  end

  def set_end_at
    self.end_at = start_at + availability.duration.minutes if availability.present?
  end

  def auto_confirm
    self.confirmed_at = Time.zone.now if availability.auto_approving?
  end
end
