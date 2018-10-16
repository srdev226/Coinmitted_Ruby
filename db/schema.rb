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

ActiveRecord::Schema.define(version: 2018_10_10_074527) do

  # These are extensions that must be enabled in order to support this database
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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "affiliate_levels", force: :cascade do |t|
    t.integer "name", default: 0, null: false
    t.integer "range_start"
    t.integer "range_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "commision", default: "0.0"
  end

  create_table "affiliations", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "affiliate_id"
    t.integer "investment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_affiliations_on_user_id"
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties_jsonb_path_ops", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.integer "affiliates_count"
    t.decimal "earnings"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "api_token"
    t.string "uuid"
    t.string "os"
    t.string "os_version"
    t.string "device_model"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "earnings", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "amount", precision: 8, scale: 2, default: "0.0"
    t.bigint "investment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investment_id"], name: "index_earnings_on_investment_id"
    t.index ["user_id"], name: "index_earnings_on_user_id"
  end

  create_table "investment_plans", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "min", precision: 10, scale: 2
    t.decimal "max", precision: 10, scale: 2
  end

  create_table "investments", force: :cascade do |t|
    t.string "name"
    t.decimal "invested_amount", precision: 8, scale: 2
    t.datetime "open_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "investment_plan_id"
    t.bigint "payout_frequency_id"
    t.bigint "payment_method_id"
    t.integer "timeframe"
    t.integer "status", default: 1
    t.decimal "expected_return", precision: 8, scale: 2, default: "0.0"
    t.decimal "investment_earning", precision: 8, scale: 2, default: "0.0"
    t.decimal "earned", precision: 8, scale: 2
    t.string "currency"
    t.index ["investment_plan_id"], name: "index_investments_on_investment_plan_id"
    t.index ["payment_method_id"], name: "index_investments_on_payment_method_id"
    t.index ["payout_frequency_id"], name: "index_investments_on_payout_frequency_id"
    t.index ["user_id"], name: "index_investments_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.string "ticker"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "investment_id"
    t.string "currencies"
    t.string "invoice"
    t.integer "confirmations"
    t.integer "max_confirmations"
    t.boolean "success"
    t.string "coin"
    t.decimal "coins_received", precision: 27, scale: 18
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investment_id"], name: "index_payments_on_investment_id"
  end

  create_table "payout_frequencies", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.text "description"
    t.string "promo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "payouts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "status", default: 0
    t.string "reference_number"
    t.date "pay_date"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.bigint "investment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investment_id"], name: "index_payouts_on_investment_id"
    t.index ["reference_number"], name: "index_payouts_on_reference_number", unique: true
    t.index ["user_id"], name: "index_payouts_on_user_id"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string "number"
    t.boolean "verified"
    t.bigint "profile_id"
    t.boolean "default"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verification_code"
    t.string "dial_code"
    t.string "full_number"
    t.index ["profile_id"], name: "index_phone_numbers_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.text "bio"
    t.integer "gender"
    t.string "language"
    t.string "currency"
    t.string "country"
    t.string "member"
    t.boolean "notification_news"
    t.boolean "notification_deposit"
    t.boolean "notification_payout"
    t.boolean "notification_alert"
    t.boolean "deleted"
    t.boolean "wallet_pin_enabled"
    t.string "wallet_pin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "membership"
    t.decimal "balance", precision: 8, scale: 2, default: "0.0"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "rates", force: :cascade do |t|
    t.string "from"
    t.string "to"
    t.decimal "rate", precision: 26, scale: 16
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "old_rate", precision: 26, scale: 16, default: "0.0"
  end

  create_table "saved_investments", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "invested_amount"
    t.datetime "open_date"
    t.datetime "end_date"
    t.integer "investment_plan_id"
    t.integer "payout_frequency_id"
    t.integer "payment_method_id"
    t.integer "timeframe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.index ["user_id"], name: "index_saved_investments_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "wallet_id"
    t.string "name"
    t.string "ticker"
    t.string "address"
    t.decimal "amount", precision: 16, scale: 8
    t.integer "flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wallet_id"], name: "index_transactions_on_wallet_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "superadmin"
    t.integer "role"
    t.string "affiliate_token"
    t.integer "affiliate_id"
    t.integer "affiliate_link_visits", default: 0, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "second_factor_attempts_count", default: 0
    t.string "encrypted_otp_secret_key"
    t.string "encrypted_otp_secret_key_iv"
    t.string "encrypted_otp_secret_key_salt"
    t.string "direct_otp"
    t.datetime "direct_otp_sent_at"
    t.datetime "totp_timestamp"
    t.boolean "enable_two_factor", default: false
    t.index ["affiliate_id"], name: "index_users_on_affiliate_id"
    t.index ["affiliate_token"], name: "index_users_on_affiliate_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["encrypted_otp_secret_key"], name: "index_users_on_encrypted_otp_secret_key", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_campaigns", force: :cascade do |t|
    t.string "name"
    t.string "referal_token"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["referal_token"], name: "index_users_campaigns_on_referal_token", unique: true
    t.index ["user_id"], name: "index_users_campaigns_on_user_id"
  end

  create_table "users_investments", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2
    t.bigint "user_id"
    t.integer "affiliate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_users_investments_on_user_id"
  end

  create_table "wallet_currencies", force: :cascade do |t|
    t.string "name"
    t.string "ticker"
    t.bigint "wallet_id"
    t.decimal "amount", precision: 16, scale: 8, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wallet_id"], name: "index_wallet_currencies_on_wallet_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "total_in_usd", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  create_table "week_percentages", force: :cascade do |t|
    t.date "first_date"
    t.date "last_date"
    t.decimal "percentage", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "affiliations", "users"
  add_foreign_key "campaigns", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "earnings", "investments"
  add_foreign_key "earnings", "users"
  add_foreign_key "investments", "investment_plans"
  add_foreign_key "investments", "payment_methods"
  add_foreign_key "investments", "payout_frequencies"
  add_foreign_key "investments", "users"
  add_foreign_key "payments", "investments"
  add_foreign_key "payouts", "investments"
  add_foreign_key "payouts", "users"
  add_foreign_key "phone_numbers", "profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "saved_investments", "users"
  add_foreign_key "transactions", "wallets"
  add_foreign_key "users_campaigns", "users"
  add_foreign_key "users_investments", "users"
  add_foreign_key "wallet_currencies", "wallets"
  add_foreign_key "wallets", "users"
end
