require 'rails_helper'

describe "Scheduler", type: :model do
  before do
    @coach = create(:coach)
    @user  = create(:user)

    @availability   = create(:availability,
                             user: @coach,
                             size_of_group: 2)
    @availability_2 = create(:availability_recurring,
                             user: @coach,
                             start_at: Date.tomorrow + 1.week)
    @booking        = create(:booking,
                             availability: @availability,
                             coach: @coach,
                             user: @user,
                             start_at: Time.zone.parse("9:00AM") + 1.day,
                             end_at: Time.zone.parse("9:00AM") + 1.day + @availability.duration.minutes)
    @booking_2 = @booking.dup.save!
    @booking_3 = @booking.dup
    @booking_3.assign_attributes(
      start_at: Time.zone.parse("10:00AM") + 1.day,
      end_at: Time.zone.parse("10:00AM") + 1.day + @availability.duration.minutes
    )
    @booking_3.save!

    @schedule = Scheduler.new(@coach).build_schedule

    @total_days_available_count = total_days_available(@coach)
    @slots_in_one_day_count     = slots_in_one_day(@availability)
  end

  it "should build schedule Hash" do
    expect(@schedule.class).to eq(Hash)
  end


  it "should generate correct days count" do
    expect(@schedule.count).to eq(@total_days_available_count)
  end

  it "should generate correct timeslots count" do
    expect(@schedule.first[1].count).to eq(@slots_in_one_day_count)
  end

  it "should generate schedule with available date" do
    available_time = business_day_begins_at(@availability) + 2.days

    expect(@schedule.keys).to include(available_time.to_date)
  end

  it "should generate schedule without unavailable date" do
    unavailable_date = (@availability_2.end_at + 1.day).to_date

    expect(@schedule.keys).not_to include(unavailable_date)
  end

  it "should mark available timeslot as available" do
    available_time = business_day_begins_at(@availability) + 2.days

    expect(@schedule[available_time.to_date][available_time][:available]).to eq(true)
  end

  it "should mark booked timeslot as unavailable" do
    booked_time = @booking.start_at

    expect(@schedule[booked_time.to_date][booked_time][:available]).to eq(false)
  end
end

def business_day_begins_at(availability)
  Time.zone.parse(availability.beginning_of_business_day.strftime("%H:%M"))
end

def total_days_available(coach)
  return @total_days_available_count if @total_days_available_count
  @total_days_available_count = 0
  coach.availabilities.each do |av|
    start_date = Date.today > av.start_at ? Date.today : av.start_at
    if av.recurring_calendar_days.empty?
      @total_days_available_count += days_count(start_date, av.end_at)
    else
      @total_days_available_count += count_reccuring_days_available(av, start_date)
    end
  end
  @total_days_available_count
end

def count_reccuring_days_available(availability, start_date)
  count = 0
  days_count(start_date, availability.end_at).times do |n|
    date = start_date + n.days
    count += 1 if availability.recurring_calendar_days.include?(date.strftime("%A").downcase)
  end
  count
end

def days_count(start_date, end_date)
  count = (start_date.to_date..end_date.to_date).count
  count > 0 ? count : 1
end

def slots_in_one_day(availability)
  business_time = (availability.end_of_business_day - availability.beginning_of_business_day) / 1.minute
  (business_time / availability.duration).to_i
end
