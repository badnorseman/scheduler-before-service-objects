require "rails_helper"

describe Booking, type: :model do
  before do
    @coach = create(:coach)
    @availability = create(:availability,
                           user: @coach)
  end

  it "has a valid factory" do
    booking = build(:booking)
    expect(booking).to be_valid
  end

  it_behaves_like "bookable"

  it "should automatically correct end at" do
    booking = build(:booking,
                    start_at: Time.zone.parse("3:00PM") + 1.day,
                    end_at: Time.zone.parse("1:00PM") + 1.day)
    expect(booking).to be_valid
  end

  it "should have valid start at" do
    booking = build(:booking,
                    availability: @availability,
                    start_at: Time.zone.parse("10:05AM") + 1.day)
    expect(booking).to be_invalid
  end

  it "shouldn't allow double booking" do
    create(:booking,
           availability: @availability)
    booking = build(:booking,
                    availability: @availability)
    expect(booking).to be_invalid
  end
end
