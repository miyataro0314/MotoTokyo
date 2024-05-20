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

ActiveRecord::Schema[7.1].define(version: 2024_05_19_042109) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "comments", force: :cascade do |t|
    t.string "user_id", null: false
    t.bigint "spot_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_comments_on_spot_id"
  end

  create_table "difficulties", force: :cascade do |t|
    t.string "user_id", null: false
    t.bigint "spot_id", null: false
    t.integer "level", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_difficulties_on_spot_id"
  end

  create_table "parking_capacities", force: :cascade do |t|
    t.bigint "parking_id", null: false
    t.integer "capacity", null: false
    t.integer "vehicle_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parking_id"], name: "index_parking_capacities_on_parking_id"
    t.index ["vehicle_type"], name: "index_parking_capacities_on_vehicle_type"
  end

  create_table "parking_fees", force: :cascade do |t|
    t.bigint "parking_id", null: false
    t.string "description"
    t.integer "start_time"
    t.integer "end_time"
    t.integer "fee"
    t.integer "interval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parking_id"], name: "index_parking_fees_on_parking_id"
  end

  create_table "parkings", force: :cascade do |t|
    t.string "name", null: false
    t.integer "area", null: false
    t.string "postal_code", null: false
    t.string "street_address", null: false
    t.geometry "coordinate", limit: {:srid=>0, :type=>"st_point"}
    t.string "weekday_text", default: [], array: true
    t.string "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area"], name: "index_parkings_on_area"
    t.index ["coordinate"], name: "index_parkings_on_coordinate", using: :gist
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
    t.index ["spot_id"], name: "index_spot_details_on_spot_id"
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

  add_foreign_key "comments", "spots"
  add_foreign_key "comments", "users"
  add_foreign_key "difficulties", "spots"
  add_foreign_key "difficulties", "users"
  add_foreign_key "parking_capacities", "parkings"
  add_foreign_key "parking_fees", "parkings"
  add_foreign_key "spot_details", "spots"
  add_foreign_key "spots", "users", on_delete: :nullify
end
