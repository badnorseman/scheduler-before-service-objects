class Scheduler
  # we're using coach for taking availabilities and bookings
  def initialize(coach)
    @coach = coach
  end

  # generate Hash object what represends coach's schedule (we're building schedule using availabilities)
  # format: { date: {
  #                   datetime: { "time": string, "available": boolean },
  #                   datetime: { "time": string, "available": boolean },
  #                   datetime: { "time": string, "available": boolean },
  #                  }
  #           date: {
  #                   datetime: { "time": string, "available": boolean },
  #                   datetime: { "time": string, "available": boolean },
  #                   datetime: { "time": string, "available": boolean },
  #                  }
  #         }
  # Note: we do not use specific format on front end (since we do not have front end yet),
  # so this format may be changed
  def build_schedule
    total_schedule = {}
    availabilities_for(@coach).each do |availability|
      total_schedule.merge!(schedule_for_one_availability(availability))
    end
    total_schedule
  end

  private

  # this method returns same object as build_schedule method, but includes only one availability
  def schedule_for_one_availability(availability)
    schedule = {}
    array_of_available_dates(availability).each do |date|
      next if availability_recurring_and_day_unavailable?(availability, date)
      schedule[date] = timeslots_on_date(availability, date)
    end
    schedule
  end

  # build array from availability dates range
  # e.g. [28 Feb 2015, 29 Feb 2015, 30 Feb 2015]
  def array_of_available_dates(availability)
    start_date = first_available_date(availability)
    (start_date..availability.end_at).to_a
  end

  # Available date cannot be less than today
  def first_available_date(availability)
    availability.start_at > Date.today ? availability.start_at : Date.today
  end

  # true if availability recurring and date isn't available
  def availability_recurring_and_day_unavailable?(availability, date)
    if availability.recurring_calendar_days.any?
      availability.recurring_calendar_days.exclude?(date.strftime("%A").downcase)
    end
  end

  # slots for one (every) day of availability. A piece (range) of time, what can be booked.
  # format: {
  #           datetime: { "time": string, "available": boolean },
  #           datetime: { "time": string, "available": boolean },
  #           datetime: { "time": string, "available": boolean },
  #         }
  # example: {
  #           2015-02-25 9:00:00 +0000: { time: "9:00AM", available: true },
  #           2015-02-25 10:00:00 +0000: { time: "9:00AM", available: false },
  #           ....
  #           2015-02-25 20:00:00 +0000: { time: "8:00PM", available: true },
  #         }
  def timeslots_on_date(availability, date)
    timeslots = {}
    array_of_available_times(availability, date).each do |time|
      timeslots[time] =
        { time:      time.strftime("%l:%M %p"),
          available: any_openings?(time,
                                   availability.duration,
                                   availability.size_of_group) }
    end
    timeslots
  end

  # Like array of dates but for times, and for specific date.
  # e.g. [2015-02-25 9:00:00 +0000, 2015-02-25 10:00:00 +0000, ... 2015-02-25 20:00:00 +0000]
  def array_of_available_times(availability, date)
    start_time = datetime_from_date_and_time(date, availability.beginning_of_business_day)
    end_of_business_day = datetime_from_date_and_time(date, availability.end_of_business_day)
    last_time_available = end_of_business_day - availability.duration.minutes
    (start_time.to_i..last_time_available.to_i).step(availability.duration.minutes).map do |timestamp|
      Time.zone.at timestamp
    end
  end

  # compare size of spots (Available in specific time) and bookings count (booked at the same time)
  def any_openings?(start_time, duration, size_of_group)
    return false if start_time.past?
    end_time = start_time + duration.minutes
    bookings_on_time = @coach.bookings.active.select do |booking|
      (booking.start_at + 1.minute) <= end_time  &&
      (booking.end_at   - 1.minute) >= start_time
    end
    (size_of_group - bookings_on_time.size) > 0
  end

  def datetime_from_date_and_time(date, time)
    date.to_datetime.change(hour: time.strftime("%H").to_i,
                            minute: time.strftime("%M").to_i)
  end

  # availavilities with bigger priority will overwrite availability with less priority during merge
  def availabilities_for(coach)
    coach.availabilities.where("end_at >= ?", Date.today).order("priority ASC")
  end
end
