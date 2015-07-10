class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.references :user,                     index: true
      t.date       :start_at
      t.date       :end_at
      t.time       :beginning_of_business_day
      t.time       :end_of_business_day
      t.integer    :duration
      t.boolean    :auto_approving,           default: false
      t.text       :recurring_calendar_days,  default: [], array: true
      t.integer    :cancellation_period
      t.integer    :late_cancellation_fee
      t.integer    :size_of_group
      t.integer    :priority
      t.timestamps
    end
  end
end
