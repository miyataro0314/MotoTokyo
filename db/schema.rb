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

ActiveRecord::Schema[7.1].define(version: 2024_05_16_022007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "spot_details", id: :string, force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.string "postal_code"
    t.string "region"
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
    t.string "user_id", null: false
    t.string "name", null: false
    t.integer "parking", null: false
    t.integer "parking_limitation", null: false
    t.integer "category", null: false
    t.integer "area", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area"], name: "index_spots_on_area"
    t.index ["category"], name: "index_spots_on_category"
    t.index ["name"], name: "index_spots_on_name", unique: true
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "spot_details", "spots"
  add_foreign_key "spots", "users"
end
