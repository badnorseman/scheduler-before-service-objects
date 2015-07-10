# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150119160600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: true do |t|
    t.integer  "user_id"
    t.date     "start_at"
    t.date     "end_at"
    t.time     "beginning_of_business_day"
    t.time     "end_of_business_day"
    t.integer  "duration"
    t.boolean  "auto_approving",            default: false
    t.text     "recurring_calendar_days",   default: [],    array: true
    t.integer  "cancellation_period"
    t.integer  "late_cancellation_fee"
    t.integer  "size_of_group"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "availabilities", ["user_id"], name: "index_availabilities_on_user_id", using: :btree

  create_table "bookings", force: true do |t|
    t.integer  "user_id"
    t.integer  "coach_id"
    t.integer  "availability_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "cancelled_at"
    t.integer  "cancelled_by"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookings", ["availability_id"], name: "index_bookings_on_availability_id", using: :btree
  add_index "bookings", ["coach_id"], name: "index_bookings_on_coach_id", using: :btree
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name",           limit: 50, null: false
    t.string   "uniquable_name", limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["uniquable_name"], name: "index_roles_on_uniquable_name", unique: true, using: :btree

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "provider"
    t.string   "uid",                    default: "", null: false
    t.text     "tokens"
    t.string   "encrypted_password",     default: "", null: false
    t.datetime "reset_password_sent_at"
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "confirmation_token"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

end
