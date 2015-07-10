shared_examples_for "bookable" do
  it "should be an available time" do
    booking = build(:booking, availability: @availability)

    expect(@coach.bookable?(booking.start_at, booking.end_at)).to eq(true)
  end

  it "should be an available time on recurring day" do
    create(:availability_recurring, user: @coach, recurring_calendar_days: [Date.tomorrow.strftime("%A").downcase])
    start_at = (Date.tomorrow + 1.week).to_datetime.change(hour: 9)
    end_at = start_at.change(hour: 10)

    expect(@coach.bookable?(start_at, end_at)).to eq(true)
  end

  it "should be an unavailable time" do
    create(:booking, availability: @availability)
    booking = build(:booking, availability: @availability)

    expect(@coach.bookable?(booking.start_at, booking.end_at)).to eq(false)
  end

  it "should be an unavailable day" do
    start_time = (@availability.end_at.to_datetime + 1.day).change(hour: 9)
    end_time = start_time + @availability.duration.minutes

    expect(@coach.bookable?(start_time, end_time)).to eq(false)
  end
end
