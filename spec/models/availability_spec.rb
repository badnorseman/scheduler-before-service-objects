require "rails_helper"

describe Availability, type: :model do
  context "without recurring" do
    it "has a valid factory" do
      availability = build(:availability)
      expect(availability).to be_valid
    end

    it "should have start at to be less than end at" do
      availability = build(:availability,
                           start_at: Date.today,
                           end_at: Date.today - 1.day)
      expect(availability).to be_invalid
    end

    it "should have beginning of business day to be less than end of business day" do
      availability = build(:availability,
                           beginning_of_business_day: Time.zone.parse("3:00PM"),
                           end_of_business_day: Time.zone.parse("1:00PM"))
      expect(availability).to be_invalid
    end
  end

  context "with recurring" do
    it "has a valid factory" do
      availability = build(:availability_recurring)
      expect(availability).to be_valid
    end
  end
end
