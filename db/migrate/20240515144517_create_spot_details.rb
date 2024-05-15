class CreateSpotDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :spot_details, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.references :spot
      t.string :postal_code
      t.string :region
      t.string :street_address
      t.string :phone_number
      t.decimal :lat, precision: 10, scale: 7
      t.decimal :lng, precision: 10, scale: 7
      t.text :weekday_text
      t.float :rating
      t.integer :user_rating_total
      t.string :url

      t.timestamps
    end

    add_index :spot_details, :id, unique: true
  end
end
