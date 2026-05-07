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

ActiveRecord::Schema[8.0].define(version: 2026_05_07_093207) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.string "line1"
    t.string "line2"
    t.string "city"
    t.string "state"
    t.string "pincode"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "bids", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bike_id", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id", "amount"], name: "index_bids_on_bike_id_and_amount"
    t.index ["bike_id"], name: "index_bids_on_bike_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "bike_bundles", force: :cascade do |t|
    t.bigint "seller_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seller_id"], name: "index_bike_bundles_on_seller_id"
  end

  create_table "bike_images", force: :cascade do |t|
    t.bigint "bike_id", null: false
    t.integer "angle", default: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_bike_images_on_bike_id"
  end

  create_table "bike_questions", force: :cascade do |t|
    t.bigint "bike_id", null: false
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.text "answer"
    t.boolean "is_public", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_bike_questions_on_bike_id"
    t.index ["user_id"], name: "index_bike_questions_on_user_id"
  end

  create_table "bikes", force: :cascade do |t|
    t.bigint "seller_id", null: false
    t.bigint "bike_bundle_id"
    t.string "make", null: false
    t.string "model", null: false
    t.integer "year", null: false
    t.integer "engine_cc", null: false
    t.integer "bike_type", default: 0
    t.integer "fuel_type", default: 0
    t.integer "transmission", default: 0
    t.integer "status", default: 0
    t.decimal "mileage_kmpl", precision: 5, scale: 2
    t.integer "kms_driven"
    t.decimal "starting_price", precision: 12, scale: 2, null: false
    t.decimal "min_increment", precision: 8, scale: 2, default: "100.0"
    t.datetime "auction_starts_at"
    t.datetime "auction_ends_at"
    t.text "description"
    t.string "registration_number"
    t.string "rc_state"
    t.string "rejection_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_bundle_id"], name: "index_bikes_on_bike_bundle_id"
    t.index ["seller_id"], name: "index_bikes_on_seller_id"
    t.index ["status", "auction_ends_at"], name: "index_bikes_on_status_and_auction_ends_at"
  end

  create_table "disputes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "order_id", null: false
    t.integer "status", default: 0
    t.text "reason"
    t.text "resolution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_disputes_on_order_id"
    t.index ["user_id"], name: "index_disputes_on_user_id"
  end

  create_table "inspection_reports", force: :cascade do |t|
    t.bigint "inspection_id", null: false
    t.integer "category", null: false
    t.integer "severity", null: false
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inspection_id"], name: "index_inspection_reports_on_inspection_id"
  end

  create_table "inspections", force: :cascade do |t|
    t.bigint "bike_id", null: false
    t.bigint "technician_id"
    t.integer "status", default: 0
    t.datetime "scheduled_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_inspections_on_bike_id"
    t.index ["technician_id"], name: "index_inspections_on_technician_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "notification_type", default: 0
    t.string "message"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.bigint "bike_id", null: false
    t.decimal "total_amount", precision: 12, scale: 2, null: false
    t.integer "status", default: 0
    t.datetime "payment_deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_orders_on_bike_id"
    t.index ["buyer_id"], name: "index_orders_on_buyer_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "gateway"
    t.string "gateway_ref"
    t.decimal "amount", precision: 12, scale: 2
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "bike_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_reviews_on_bike_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "rto_verifications", force: :cascade do |t|
    t.bigint "bike_id", null: false
    t.integer "status", default: 0
    t.string "verified_owner"
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_rto_verifications_on_bike_id"
  end

  create_table "service_histories", force: :cascade do |t|
    t.bigint "bike_id", null: false
    t.date "service_date"
    t.string "service_center"
    t.text "work_done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_service_histories_on_bike_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "wallet_id", null: false
    t.integer "transaction_type", null: false
    t.integer "status", default: 0
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.string "reference", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_transactions_on_reference", unique: true
    t.index ["wallet_id"], name: "index_transactions_on_wallet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "phone", null: false
    t.integer "role", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "balance", precision: 12, scale: 2, default: "0.0"
    t.decimal "locked_amount", precision: 12, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "bids", "bikes"
  add_foreign_key "bids", "users"
  add_foreign_key "bike_bundles", "users", column: "seller_id"
  add_foreign_key "bike_images", "bikes"
  add_foreign_key "bike_questions", "bikes"
  add_foreign_key "bike_questions", "users"
  add_foreign_key "bikes", "bike_bundles"
  add_foreign_key "bikes", "users", column: "seller_id"
  add_foreign_key "disputes", "orders"
  add_foreign_key "disputes", "users"
  add_foreign_key "inspection_reports", "inspections"
  add_foreign_key "inspections", "bikes"
  add_foreign_key "inspections", "users", column: "technician_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "orders", "bikes"
  add_foreign_key "orders", "users", column: "buyer_id"
  add_foreign_key "payments", "orders"
  add_foreign_key "reviews", "bikes"
  add_foreign_key "reviews", "users"
  add_foreign_key "rto_verifications", "bikes"
  add_foreign_key "service_histories", "bikes"
  add_foreign_key "transactions", "wallets"
  add_foreign_key "wallets", "users"
end
