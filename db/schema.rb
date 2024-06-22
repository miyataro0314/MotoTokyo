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

ActiveRecord::Schema[7.1].define(version: 2024_06_19_112807) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "access_histories", force: :cascade do |t|
    t.string "user_id", null: false
    t.bigint "spot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_access_histories_on_spot_id"
    t.index ["user_id"], name: "index_access_histories_on_user_id"
  end

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

  create_table "bookmarks", force: :cascade do |t|
    t.string "user_id", null: false
    t.bigint "spot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_bookmarks_on_spot_id"
    t.index ["user_id", "spot_id"], name: "index_bookmarks_on_user_id_and_spot_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "user_id", null: false
    t.bigint "spot_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_comments_on_spot_id"
    t.index ["user_id", "spot_id"], name: "index_comments_on_user_id_and_spot_id", unique: true
  end

  create_table "difficulties", force: :cascade do |t|
    t.string "user_id", null: false
    t.bigint "spot_id", null: false
    t.integer "level", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_difficulties_on_spot_id"
    t.index ["user_id", "spot_id"], name: "index_difficulties_on_user_id_and_spot_id", unique: true
  end

  create_table "edit_histories", force: :cascade do |t|
    t.string "user_id", null: false
    t.bigint "spot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_edit_histories_on_spot_id"
    t.index ["user_id", "spot_id"], name: "index_edit_histories_on_user_id_and_spot_id", unique: true
    t.index ["user_id"], name: "index_edit_histories_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "friend_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "title", null: false
    t.text "message", null: false
    t.string "url", null: false
    t.integer "notification_type", null: false
    t.integer "priority", default: 0, null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_type"], name: "index_notifications_on_notification_type"
    t.index ["read"], name: "index_notifications_on_read"
  end

  create_table "parkings", force: :cascade do |t|
    t.string "name", null: false
    t.integer "area", null: false
    t.string "address", null: false
    t.geography "coordinate", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "fee"
    t.string "closed_days"
    t.string "opening_hours"
    t.string "capacity"
    t.string "limitation"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "postal_code"
    t.index ["area"], name: "index_parkings_on_area"
    t.index ["coordinate"], name: "index_parkings_on_coordinate", using: :gist
  end

  create_table "profiles", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "user_name", null: false
    t.string "vehicle_name"
    t.integer "vehicle_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "search_histories", force: :cascade do |t|
    t.string "user_id", null: false
    t.integer "search_query"
    t.integer "parking"
    t.integer "category"
    t.integer "area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_search_histories_on_user_id"
  end

  create_table "spot_details", id: :string, force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.string "postal_code"
    t.string "street_address"
    t.string "phone_number"
    t.geography "coordinate", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "weekday_text", default: [], array: true
    t.float "rating"
    t.integer "user_rating_total"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordinate"], name: "index_spot_details_on_coordinate", using: :gist
    t.index ["spot_id"], name: "index_spot_details_on_spot_id", unique: true
  end

  create_table "spots", force: :cascade do |t|
    t.string "user_id"
    t.string "name", null: false
    t.integer "parking", null: false
    t.integer "parking_limitation"
    t.integer "category", null: false
    t.integer "area", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area"], name: "index_spots_on_area"
    t.index ["category"], name: "index_spots_on_category"
    t.index ["name"], name: "index_spots_on_name", unique: true
    t.index ["parking"], name: "index_spots_on_parking"
    t.index ["parking_limitation"], name: "index_spots_on_parking_limitation"
    t.index ["user_id"], name: "index_spots_on_user_id"
  end

  create_table "users", id: :string, default: "", force: :cascade do |t|
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
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "access_histories", "spots"
  add_foreign_key "access_histories", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "spots"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "comments", "spots"
  add_foreign_key "comments", "users"
  add_foreign_key "difficulties", "spots"
  add_foreign_key "difficulties", "users"
  add_foreign_key "edit_histories", "spots"
  add_foreign_key "edit_histories", "users"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "search_histories", "users"
  add_foreign_key "spot_details", "spots"
  add_foreign_key "spots", "users", on_delete: :nullify
end
