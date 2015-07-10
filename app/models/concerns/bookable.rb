module Bookable
  extend ActiveSupport::Concern

  included do
    has_many :availabilities, foreign_key: :user_id, dependent: :destroy
    has_many :bookings, class: Booking, foreign_key: :coach_id
  end

  def bookable?(start_dt, end_dt)
    if times_are_valid?(start_dt, end_dt)
      bookings_on(start_dt, end_dt) < size_of_group(start_dt, end_dt)
    end
  end

  private

  def times_are_valid?(start_dt, end_dt)
    start_dt >= Time.zone.now && end_dt > start_dt
  end

  def size_of_group(start_dt, end_dt)
    availability = availabilitities_on(start_dt, end_dt)
    availability ? availability.size_of_group : null_availability
  end

  def availabilitities_on(start_dt, end_dt)
    availabilities.where(":date >= start_at AND
                         :date <= end_at AND
                         :start_time >= beginning_of_business_day AND
                         :end_time <= end_of_business_day AND
                         (recurring_calendar_days = '{}' OR
                          recurring_calendar_days @> :calendar_day::text[])",
                         date: start_dt.to_date,
                         start_time: start_dt.strftime("%H:%M:00"),
                         end_time: end_dt.strftime("%H:%M:00"),
                         calendar_day: "{#{start_dt.strftime("%A").downcase}}")
                         .order("priority DESC")
                         .first
  end

  def bookings_on(start_dt, end_dt)
    bookings.where(":start_datetime <= end_at AND
                   :end_datetime >= start_at",
                   start_datetime: start_dt + 1.minute,
                   end_datetime: end_dt - 1.minute)
                  .count
  end

  def null_availability
    0
  end
end
