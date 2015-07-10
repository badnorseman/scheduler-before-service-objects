class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :user,         index: true
      t.references :coach,        index: true
      t.references :availability, index: true
      t.datetime   :start_at
      t.datetime   :end_at
      t.datetime   :cancelled_at
      t.integer    :cancelled_by
      t.datetime   :confirmed_at
      t.timestamps
    end
  end
end
