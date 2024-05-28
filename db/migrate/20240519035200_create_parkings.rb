class CreateParkings < ActiveRecord::Migration[7.1]
  def change
    create_table :parkings do |t|
      t.string :name, null: false
      t.integer :area, null: false
      t.string :address, null: false
      t.st_point :coordinate, geographic: true
      t.string :fee
      t.string :closed_days
      t.string :opening_hours
      t.string :capacity
      t.string :limitation
      t.string :url

      t.timestamps
    end

    add_index :parkings, :area
    add_index :parkings, :coordinate, using: :gist
  end
end
