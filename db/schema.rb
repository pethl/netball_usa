# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_03_28_103845) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "educators", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "school_name"
    t.string "city"
    t.string "state"
    t.text "educator_notes"
    t.text "mgmt_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "event_assignments", force: :cascade do |t|
    t.bigint "umpire_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_assignments_on_event_id"
    t.index ["umpire_id"], name: "index_event_assignments_on_umpire_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_type"
    t.string "name"
    t.datetime "date"
    t.string "website"
    t.text "key_contact"
    t.string "city"
    t.string "state"
    t.string "location"
    t.text "details"
    t.string "booth"
    t.text "cost_notes"
    t.string "status"
    t.string "outcome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grants", force: :cascade do |t|
    t.string "name"
    t.boolean "apply"
    t.integer "amount"
    t.string "location"
    t.datetime "due_date"
    t.text "purpose"
    t.string "grant_link"
    t.text "notes"
    t.string "status"
    t.datetime "date_submitted"
    t.string "program"
    t.string "application_link"
    t.string "login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "netball_educators", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "school_name"
    t.string "city"
    t.string "state"
    t.text "educator_notes"
    t.text "mgmt_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "feedback"
    t.boolean "authorize"
    t.string "level"
    t.string "website"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.string "region"
    t.string "location"
    t.string "email"
    t.string "level"
    t.string "phone"
    t.string "address"
    t.string "associated"
    t.string "gender"
    t.string "tshirt_size"
    t.string "uniform_size"
    t.boolean "headshot"
    t.string "headshot_file"
    t.boolean "invite_back"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "level_note"
  end

  create_table "references", force: :cascade do |t|
    t.string "group"
    t.string "value"
    t.string "key"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
  end

  create_table "sponsors", force: :cascade do |t|
    t.string "category"
    t.string "industry"
    t.string "company_name"
    t.string "status"
    t.text "about"
    t.string "location"
    t.string "website"
    t.text "key_contacts"
    t.string "phone_numbers_emails"
    t.string "opportunity_area"
    t.string "pitch"
    t.text "follow_up_actions"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.datetime "check_in"
    t.datetime "check_out"
    t.string "room_type"
    t.string "hotel_reservation"
    t.string "share_volunteer"
    t.string "arrival_airline"
    t.string "arrival_flight"
    t.datetime "arrival_time"
    t.string "departure_airline"
    t.string "departure_flight"
    t.datetime "departure_time"
    t.boolean "no_pick_up"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "umpires", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.string "region"
    t.string "location"
    t.string "email"
    t.string "level"
    t.string "phone"
    t.string "address"
    t.string "associated"
    t.string "gender"
    t.string "tshirt_size"
    t.string "uniform_size"
    t.boolean "headshot"
    t.string "headshot_file"
    t.boolean "invite_back"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "level_note"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "event_assignments", "events"
  add_foreign_key "event_assignments", "umpires"
end
