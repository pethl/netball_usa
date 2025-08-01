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

ActiveRecord::Schema[7.1].define(version: 2025_07_28_075959) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
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

  create_table "clubs", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "us_state"
    t.string "membership_category"
    t.string "website"
    t.string "facebook"
    t.string "twitter"
    t.string "instagram"
    t.text "other_sm"
    t.integer "estimate_total_number_of_club_members"
    t.integer "estimate_total_active_members"
    t.integer "estimate_total_part_time_members"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "admin_notes"
    t.text "renewal_years"
    t.string "renewal_response"
    t.string "email"
    t.bigint "netball_association_id"
    t.index ["netball_association_id"], name: "index_clubs_on_netball_association_id"
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
    t.integer "partner_id"
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
    t.bigint "person_id"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "netball_educator_id"
    t.index ["event_id", "netball_educator_id"], name: "index_event_participants_on_event_and_netball_educator", unique: true
    t.index ["event_id"], name: "index_event_participants_on_event_id"
    t.index ["netball_educator_id"], name: "index_event_participants_on_netball_educator_id"
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
    t.string "attend"
    t.string "is_educational", default: "No"
    t.date "proposal_submission_due"
    t.date "booth_registration_due"
    t.integer "assigned_user_id"
    t.uuid "key_pe_director_id"
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

  create_table "frequent_flyer_numbers", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.string "airline"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_frequent_flyer_numbers_on_person_id"
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
    t.datetime "notification_date"
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
    t.integer "user_id"
    t.string "phone"
    t.string "address"
    t.string "zip"
    t.integer "club_id"
    t.integer "team_id"
    t.string "discount_code"
    t.string "country"
    t.text "renewal_years"
    t.string "renewal_response"
  end

  create_table "media", force: :cascade do |t|
    t.string "media_type"
    t.string "company_name"
    t.string "contact_name"
    t.string "contact_position"
    t.string "email"
    t.string "phone"
    t.string "city"
    t.string "state"
    t.string "country"
    t.text "pitch"
    t.string "media_announcement_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "action_taken"
    t.string "region_other"
    t.string "company_website"
    t.string "socials"
    t.text "notes"
    t.integer "user_id"
    t.integer "old_user_id"
    t.string "contact_email"
    t.string "facebook"
    t.string "twitter"
    t.string "instagram"
    t.string "event_calender_link"
    t.string "calendar_login_details"
    t.date "release_date"
  end

  create_table "member_key_roles", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.string "key_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "na_teams_id"
    t.integer "na_team_id"
    t.integer "club_id"
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
    t.integer "club_id"
    t.string "phone"
    t.string "address"
    t.string "zip"
    t.integer "team_id"
    t.boolean "join_a_committee"
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

  create_table "netball_academies", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "city"
    t.string "us_state"
    t.string "country"
    t.bigint "club_id"
    t.string "other_club_name"
    t.string "status"
    t.date "signed_up"
    t.date "purchase_date"
    t.string "subscribed_plans"
    t.decimal "amount"
    t.date "training_completed_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_netball_academies_on_club_id"
  end

  create_table "netball_associations", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "email"
    t.string "website"
    t.string "facebook"
    t.string "twitter"
    t.string "instagram"
    t.text "notes"
    t.bigint "user_id", null: false
    t.integer "number_of_clubs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_netball_associations_on_user_id"
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
    t.string "address"
    t.string "title"
    t.string "zip"
    t.boolean "is_pe_director"
    t.string "role"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.bigint "club_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_notes_on_club_id"
  end

  create_table "open_invites", force: :cascade do |t|
    t.string "status"
    t.boolean "invite_sent"
    t.date "invite_sent_date"
    t.boolean "rspv"
    t.boolean "whova"
    t.boolean "flight_booked"
    t.boolean "sent_save_the_date"
    t.boolean "response_to_save_the_date"
    t.boolean "send_official_invite"
    t.text "comments"
    t.bigint "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_open_invites_on_person_id"
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
    t.datetime "date_submitted"
    t.text "in_progress_status"
    t.index ["sponsor_id"], name: "index_opportunities_on_sponsor_id"
    t.index ["user_id"], name: "index_opportunities_on_user_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "company"
    t.text "description"
    t.string "location"
    t.string "city"
    t.string "website"
    t.datetime "date_initially_connected"
    t.datetime "date_pitch_to_na"
    t.datetime "date_pitch_by_na"
    t.text "pitch_to_na"
    t.text "pitch_by_na"
    t.text "follow_up_action"
    t.text "partnership_agreement"
    t.string "accept_partnership"
    t.datetime "date_of_decision"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name_primary"
    t.string "last_name_primary"
    t.string "role_primary"
    t.string "email_primary"
    t.string "cell_primary"
    t.string "work_phone_primary"
    t.string "first_name_secondary"
    t.string "last_name_secondary"
    t.string "role_secondary"
    t.string "email_secondary"
    t.string "cell_secondary"
    t.string "work_phone_secondary"
    t.string "first_name_third"
    t.string "last_name_third"
    t.string "role_third"
    t.string "email_third"
    t.string "cell_third"
    t.string "work_phone_third"
    t.string "us_state"
    t.string "country"
    t.bigint "user_id"
    t.integer "old_user_id"
    t.index ["user_id"], name: "index_partners_on_user_id"
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
    t.integer "club_id"
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
    t.text "resume_data"
    t.string "status", default: "Active", null: false
    t.string "educator_role"
    t.string "inferno_bottom_skirt_size"
    t.string "inferno_bottom_shorts_size"
    t.string "inferno_top_polo_size"
    t.string "inferno_top_vneck_size"
  end

  create_table "press_releases", force: :cascade do |t|
    t.string "media_announcement_link"
    t.date "release_date"
    t.string "title"
    t.text "content"
    t.bigint "medium_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "index_press_releases_on_medium_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "program_stage"
    t.string "program_name"
    t.string "na_program_contact_email"
    t.string "na_program_contact_phone"
    t.string "location_name"
    t.string "location_contact_phone"
    t.string "location_contact_email"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.bigint "person_id"
    t.datetime "program_event_datetime"
    t.string "timezone"
    t.string "funded_by"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_programs_on_person_id"
  end

  create_table "reference_vendors", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.bigint "reference_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference_id"], name: "index_reference_vendors_on_reference_id"
    t.index ["vendor_id"], name: "index_reference_vendors_on_vendor_id"
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
    t.string "expat_co"
    t.string "other_link"
    t.string "other_locations"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "club_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "tours", force: :cascade do |t|
    t.string "company"
    t.text "description"
    t.text "location"
    t.string "city"
    t.string "us_state"
    t.string "website"
    t.datetime "date_initially_connected"
    t.datetime "date_pitch_to_na"
    t.datetime "date_pitch_by_na"
    t.text "pitch_to_na"
    t.text "pitch_by_na"
    t.text "follow_up_action"
    t.text "tour_agreement"
    t.string "accept_tour"
    t.datetime "date_of_decision"
    t.string "first_name_primary"
    t.string "last_name_primary"
    t.string "role_primary"
    t.string "email_primary"
    t.string "cell_primary"
    t.string "work_phone_primary"
    t.string "first_name_secondary"
    t.string "last_name_secondary"
    t.string "role_secondary"
    t.string "email_secondary"
    t.string "cell_secondary"
    t.string "work_phone_secondary"
    t.string "first_name_third"
    t.string "last_name_third"
    t.string "role_third"
    t.string "email_third"
    t.string "cell_third"
    t.string "work_phone_third"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
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
    t.string "arrival_phone"
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
    t.string "arrival_terminal"
    t.string "departure_terminal"
    t.string "pickup_location"
    t.boolean "obtain_headshot"
    t.string "arrival_airport_transport_request"
    t.datetime "grouping_pickup_time"
    t.datetime "grouping_departure_time"
    t.string "departure_meetup_location"
    t.string "hotel_confirmation_personal"
    t.string "dietary_requirements_allergies"
    t.string "departure_airport_transport_request"
    t.string "departure_phone"
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

  create_table "vendors", force: :cascade do |t|
    t.string "company_name"
    t.string "contact_name"
    t.string "email"
    t.string "phone"
    t.string "website"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "venues", force: :cascade do |t|
    t.string "facility_type"
    t.string "venue_name"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "website"
    t.string "contact_name"
    t.string "phone"
    t.string "email"
    t.string "permit_application_link"
    t.string "grant_information_link"
    t.string "number_of_courts"
    t.string "size_of_courts"
    t.string "retractable_basketball_hoops"
    t.string "space_from_courts_to_wall"
    t.string "seating_available"
    t.text "restaurant_onsite"
    t.text "facilities_close_by"
    t.string "locker_rooms_onsite"
    t.string "pool"
    t.string "hot_tub"
    t.string "bed_types"
    t.decimal "cost_per_hour"
    t.decimal "cost_per_day"
    t.decimal "cost_per_night"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
  end

  create_table "versions", force: :cascade do |t|
    t.string "whodunnit"
    t.datetime "created_at"
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.string "event", null: false
    t.text "object"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clubs", "netball_associations"
  add_foreign_key "clubs", "users"
  add_foreign_key "contacts", "grants"
  add_foreign_key "contacts", "sponsors"
  add_foreign_key "equipment", "netball_educators"
  add_foreign_key "equipment", "people"
  add_foreign_key "event_assignments", "events"
  add_foreign_key "event_assignments", "umpires"
  add_foreign_key "event_participants", "events"
  add_foreign_key "event_participants", "people"
  add_foreign_key "frequent_flyer_numbers", "people"
  add_foreign_key "individual_members", "clubs"
  add_foreign_key "individual_members", "teams"
  add_foreign_key "member_key_roles", "clubs"
  add_foreign_key "member_key_roles", "members"
  add_foreign_key "members", "clubs"
  add_foreign_key "members", "teams"
  add_foreign_key "netball_academies", "clubs"
  add_foreign_key "netball_associations", "users"
  add_foreign_key "notes", "clubs"
  add_foreign_key "open_invites", "people"
  add_foreign_key "opportunities", "sponsors"
  add_foreign_key "opportunities", "users"
  add_foreign_key "partners", "users"
  add_foreign_key "payments", "clubs"
  add_foreign_key "payments", "individual_members"
  add_foreign_key "payments", "na_teams"
  add_foreign_key "payments", "users", column: "payment_recorded_by_id"
  add_foreign_key "press_releases", "media"
  add_foreign_key "programs", "people"
  add_foreign_key "reference_vendors", "references"
  add_foreign_key "reference_vendors", "vendors"
  add_foreign_key "teams", "users"
  add_foreign_key "transfers", "events"
  add_foreign_key "transfers", "people"
end
