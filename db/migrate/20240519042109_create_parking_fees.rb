class CreateParkingFees < ActiveRecord::Migration[7.1]
  def change
    create_table :parking_fees do |t|
      t.references :parking, null: false, foreign_key: true, index: true
      t.string :description
      t.integer :start_time
      t.integer :end_time
      t.integer :hourly_rate

      t.timestamps
    end

    add_index :parking_fees, :hourly_rate
  end
end

ActiveRecord::Schema[7.1].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

end