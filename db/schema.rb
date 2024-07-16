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

ActiveRecord::Schema[7.0].define(version: 2024_07_16_092134) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "budgets", force: :cascade do |t|
    t.decimal "flight", precision: 7, scale: 2
    t.text "flight_notes"
    t.decimal "hotel", precision: 7, scale: 2
    t.text "hotel_notes"
    t.decimal "transport", precision: 7, scale: 2
    t.text "transport_notes"
    t.decimal "shipping", precision: 7, scale: 2
    t.text "shipping_notes"
    t.decimal "booth", precision: 7, scale: 2
    t.text "booth_notes"
    t.decimal "carpet", precision: 7, scale: 2
    t.text "carpet_notes"
    t.decimal "banners", precision: 7, scale: 2
    t.string "banner_notes"
    t.decimal "giveaways", precision: 7, scale: 2
    t.text "giveaway_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.decimal "per_diem", precision: 7, scale: 2
    t.integer "number_of_people"
    t.decimal "number_of_days", precision: 7, scale: 2
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "prefix"
    t.string "suffix"
    t.string "nickname"
    t.string "email"
    t.string "phone"
    t.string "linked_in"
    t.string "job_title"
    t.string "department"
    t.string "organisation"
    t.bigint "sponsor_id"
    t.bigint "grant_id"
    t.string "location"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mobile"
    t.index ["grant_id"], name: "index_contacts_on_grant_id"
    t.index ["sponsor_id"], name: "index_contacts_on_sponsor_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.text "items_purchased"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.datetime "sale_date"
    t.uuid "netball_educator_id"
    t.decimal "purchase_amount"
  end

  create_table "event_assignments", force: :cascade do |t|
    t.bigint "umpire_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_assignments_on_event_id"
    t.index ["umpire_id"], name: "index_event_assignments_on_umpire_id"
  end

  create_table "event_participants", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_participants_on_event_id"
    t.index ["person_id"], name: "index_event_participants_on_person_id"
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
    t.datetime "end_date"
  end

  create_table "follow_ups", force: :cascade do |t|
    t.string "lead_type"
    t.string "status"
    t.text "action_items"
    t.decimal "sale_amount", precision: 7, scale: 2
    t.boolean "add_to_mailing_list"
    t.integer "event_id"
    t.string "netball_educator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
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
    t.string "timezone"
    t.datetime "action_by"
    t.string "state"
    t.integer "old_user_id"
  end

  create_table "individual_members", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "city"
    t.string "state"
    t.string "gender"
    t.boolean "interested_in_coaching"
    t.boolean "interested_in_umpiring"
    t.boolean "interested_in_usa_team"
    t.string "place_of_birth"
    t.string "age_status"
    t.string "engagement_status"
    t.string "membership_type"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_key_roles", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.string "key_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "na_teams_id"
    t.integer "na_team_id"
    t.index ["member_id"], name: "index_member_key_roles_on_member_id"
    t.index ["na_teams_id"], name: "index_member_key_roles_on_na_teams_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email"
    t.string "city"
    t.string "state"
    t.string "gender"
    t.boolean "interested_in_coaching"
    t.boolean "interested_in_umpiring"
    t.boolean "interested_in_usa_team"
    t.datetime "dob"
    t.string "place_of_birth"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "age_status"
    t.bigint "na_team_id"
    t.string "engagement_status"
    t.string "membership_type"
    t.index ["na_team_id"], name: "index_members_on_na_team_id"
  end

  create_table "na_teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_key_role_id"
    t.bigint "member_id"
    t.string "website"
    t.string "facebook"
    t.string "twitter"
    t.string "instagram"
    t.text "other_sm"
    t.index ["member_id"], name: "index_na_teams_on_member_id"
    t.index ["member_key_role_id"], name: "index_na_teams_on_member_key_role_id"
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

  create_table "opportunities", force: :cascade do |t|
    t.bigint "sponsor_id"
    t.string "status"
    t.bigint "user_id"
    t.string "opportunity_type"
    t.string "website"
    t.string "area"
    t.text "pitch"
    t.text "follow_up_actions"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "old_user_id"
    t.integer "contact_id"
    t.string "outcome"
    t.datetime "outcome_date"
    t.text "outcome_received"
    t.index ["sponsor_id"], name: "index_opportunities_on_sponsor_id"
    t.index ["user_id"], name: "index_opportunities_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "payment_year"
    t.string "payment_type"
    t.bigint "na_team_id"
    t.bigint "individual_member_id"
    t.bigint "payment_recorded_by_id"
    t.datetime "payment_received_date"
    t.string "payment_transaction_reference"
    t.text "payment_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount", precision: 7, scale: 2
    t.index ["individual_member_id"], name: "index_payments_on_individual_member_id"
    t.index ["na_team_id"], name: "index_payments_on_na_team_id"
    t.index ["payment_recorded_by_id"], name: "index_payments_on_payment_recorded_by_id"
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
    t.boolean "headshot_present"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "level_note"
    t.boolean "in_person_trained"
    t.boolean "virtually_trained"
    t.boolean "booth_trained"
    t.text "accept_notes"
    t.string "description"
    t.text "image_data"
    t.string "headshot_path"
    t.string "invite_back"
    t.datetime "certification_date"
    t.text "headshot_data"
    t.text "certification_data"
    t.string "level_submitted"
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

  create_table "regions", force: :cascade do |t|
    t.string "state"
    t.string "region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sample_words", force: :cascade do |t|
    t.string "category"
    t.string "title"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sponsors", force: :cascade do |t|
    t.string "sponsor_category"
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
    t.string "city"
    t.string "state"
    t.string "sponsor_type"
    t.integer "old_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "state"
    t.string "city"
    t.string "website"
    t.string "facebook"
    t.string "twitter"
    t.string "instagram"
    t.string "other_sm"
    t.index ["user_id"], name: "index_teams_on_user_id"
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
    t.string "phone"
    t.string "hotel_name"
    t.integer "pick_up_grouping"
    t.string "pickup_type"
    t.string "pickup_note"
    t.integer "departure_grouping"
    t.string "departure_type"
    t.string "departure_note"
    t.string "umpire_badge_level"
    t.datetime "certification_date"
    t.string "visa_type"
    t.string "t_shirt_size"
    t.text "headshot_data"
    t.text "certification_data"
    t.bigint "event_id"
    t.bigint "person_id"
    t.string "event_title"
    t.boolean "registration_form_completed"
    t.boolean "waiver_form_completed"
    t.boolean "read_and_agreed_tcs"
    t.string "hotel_arrival"
    t.string "hotel_departure"
    t.boolean "consent"
    t.index ["event_id"], name: "index_transfers_on_event_id"
    t.index ["person_id"], name: "index_transfers_on_person_id"
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
    t.boolean "approved", default: false, null: false
    t.integer "role", default: 2
    t.boolean "account_active", default: true
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contacts", "grants"
  add_foreign_key "contacts", "sponsors"
  add_foreign_key "equipment", "netball_educators"
  add_foreign_key "equipment", "people"
  add_foreign_key "event_assignments", "events"
  add_foreign_key "event_assignments", "umpires"
  add_foreign_key "event_participants", "events"
  add_foreign_key "event_participants", "people"
  add_foreign_key "member_key_roles", "members"
  add_foreign_key "opportunities", "sponsors"
  add_foreign_key "opportunities", "users"
  add_foreign_key "payments", "individual_members"
  add_foreign_key "payments", "na_teams"
  add_foreign_key "payments", "users", column: "payment_recorded_by_id"
  add_foreign_key "teams", "users"
  add_foreign_key "transfers", "events"
  add_foreign_key "transfers", "people"
end
