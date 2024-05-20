class CreateParkings < ActiveRecord::Migration[7.1]
  def change
    create_table :parkings do |t|
      t.string :name, null: false
      t.integer :area, null: false
      t.string :postal_code, null: false
      t.string :street_address, null: false
      t.st_point :coordinate
      t.string :weekday_text, array: true, default: []
      t.string :info

      t.timestamps
    end

    add_index :parkings, :area
    add_index :parkings, :coordinate, using: :gist
  end
end
