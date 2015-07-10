FactoryGirl.define do
  factory :availability do
    user
    start_at                  Date.today
    sequence(:end_at)         { start_at + 1.week if start_at.present? }
    beginning_of_business_day Time.zone.parse("9:00AM")
    end_of_business_day       Time.zone.parse("9:00PM")
    duration                  60
    auto_approving            false
    cancellation_period       24
    late_cancellation_fee     50

    factory :availability_recurring do
      start_at                Date.today + 1.week
      recurring_calendar_days { ["monday", "wednesday", "friday"] }
    end
  end
end
