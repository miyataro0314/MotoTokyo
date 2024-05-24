class CreateParkingFees < ActiveRecord::Migration[7.1]
  def change
    create_table :parking_fees do |t|
      t.references :parking, null: false, foreign_key: true, index: true
      t.string :description
      t.string :start_time
      t.string :end_time
      t.integer :fee
      t.integer :interval

      t.timestamps
    end
  end
end
