class CreateSpotDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :spot_details, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.references :spot, null: false, foreign_key: true
      t.string :postal_code
      t.string :region
      t.string :street_address
      t.string :phone_number
      t.st_point :coordinate, geographic: true
      t.string :weekday_text, array: true, default: []
      t.float :rating
      t.integer :user_rating_total
      t.string :url

      t.timestamps
    end

    add_index :spot_details, :coordinate, using: :gist
  end
end