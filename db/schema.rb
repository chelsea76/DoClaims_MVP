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

ActiveRecord::Schema.define(version: 20180407054920) do

  create_table "attachments", force: :cascade do |t|
    t.string   "file_type"
    t.integer  "claim_id"
    t.integer  "damage_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["claim_id"], name: "index_attachments_on_claim_id", using: :btree
    t.index ["damage_id"], name: "index_attachments_on_damage_id", using: :btree
  end
>>>>>>> Support for attachments

  create_table "calendars", force: :cascade do |t|
    t.date     "day"
    t.integer  "price"
    t.integer  "status"
    t.integer  "claim_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_id"], name: "index_calendars_on_claim_id"
  end

  create_table "claim_additional_details", force: :cascade do |t|
    t.integer  "insured_id"
    t.integer  "claimant_id"
    t.boolean  "is_cat", default: false
    t.string  "cat_id"
    t.float    "excess_amount", limit: 24
    t.integer  "claim_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["claim_id"], name: "index_claim_additional_details_on_claim_id", using: :btree
  end

  create_table "claim_contact_mappings", force: :cascade do |t|
    t.integer  "claim_id"
    t.integer  "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "for_claim",  default: false
    t.index ["claim_id"], name: "index_claim_contact_mappings_on_claim_id", using: :btree
    t.index ["contact_id"], name: "index_claim_contact_mappings_on_contact_id", using: :btree
  end

  create_table "claims", force: :cascade do |t|
    t.string   "claim_type"
    t.string   "incident_type"
    t.string   "sub_incident_type"
    t.string   "status"
    t.string   "policy_ref"
    t.datetime "claim_reported_date"
    t.datetime "claim_loss_date"
    t.integer  "claim_reference_carrier"
    t.integer  "claim_reference_external"
    t.string   "claim_reference_external_note"
    t.integer  "bed_room"
    t.integer  "bath_room"
    t.string   "listing_name"
    t.text     "summary"
    t.string   "address"
    t.boolean  "is_contents"
    t.boolean  "is_commercial"
    t.integer  "claim_mgr_min_rating"
    t.string   "fee_type"
    t.integer  "max_fee"
    t.integer  "fee_win_now_price"
    t.string   "workflow"
    t.boolean  "wkflow_makesafe"
    t.boolean  "wkflow_claim_manager"
    t.boolean  "wkflow_site_visit"
    t.boolean  "wkflow_report_first"
    t.boolean  "wkflow_report_final"
    t.boolean  "wkflow_first_and_final"
    t.boolean  "wkflow_QA"
    t.integer  "price"
    t.integer  "value"
    t.boolean  "active"
    t.string   "insurer"
    t.integer  "user_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "instant",                       default: 1
    t.index ["user_id"], name: "index_claims_on_user_id"
  end

  create_table "contacts", force: :cascade  do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "type"
    t.string   "other"
    t.string   "mobile"
    t.string   "office"
    t.integer  "user_id"
    t.string   "con_type"
    t.string   "number"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "postcode"
    t.string   "country"
    t.string   "preferred_method", default: "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_contacts_on_user_id", using: :btree
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "damages", force: :cascade do |t|
    t.string   "description"
    t.text     "summary",            limit: 65535
    t.string   "damage_type"
    t.string   "sub_type"
    t.float    "product_cost",       limit: 24
    t.float    "labour_cost",        limit: 24
    t.integer  "claim_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["claim_id"], name: "index_damages_on_claim_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "context"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "claim_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "price"
    t.integer  "total"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0
    t.index ["claim_id"], name: "index_reservations_on_claim_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "comment"
    t.integer  "star",           default: 1
    t.integer  "claim_id"
    t.integer  "reservation_id"
    t.integer  "guest_id"
    t.integer  "host_id"
    t.string   "type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["claim_id"], name: "index_reviews_on_claim_id"
    t.index ["guest_id"], name: "index_reviews_on_guest_id"
    t.index ["host_id"], name: "index_reviews_on_host_id"
    t.index ["reservation_id"], name: "index_reviews_on_reservation_id"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean  "enable_sms",   default: true
    t.boolean  "enable_email", default: true
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "task_hours_logs", force: :cascade do |t|
    t.float    "minutes_logged", limit: 24
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["task_id"], name: "index_task_hours_logs_on_task_id", using: :btree
    t.index ["user_id"], name: "index_task_hours_logs_on_user_id", using: :btree
  end

  create_table "task_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "claim_id"
    t.integer  "task_type_id"
    t.string   "title"
    t.text     "description",      limit: 65535
    t.string   "status"
    t.string   "milestone"
    t.string   "deliverable_type"
    t.string   "RAG_status"
    t.datetime "task_due"
    t.datetime "task_completed"
    t.integer  "minutes_logged"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["claim_id"], name: "index_tasks_on_claim_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "fullname"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.string   "phone_number"
    t.text     "description"
    t.string   "pin"
    t.boolean  "phone_verified"
    t.string   "stripe_id"
    t.string   "merchant_id"
    t.integer  "unread",                 default: 0
    t.string   "preferred_location"
    t.float    "pref_latitude"
    t.float    "pref_longtitude"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
