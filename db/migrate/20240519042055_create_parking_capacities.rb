class CreateParkingCapacities < ActiveRecord::Migration[7.1]
  def change
    create_table :parking_capacities do |t|
      t.references :parking, null: false, foreign_key: true, index: true
      t.integer :type , null: false
      t.integer :capacity, null: false

      t.timestamps
    end

    add_index :parking_capacities, :type
  end
end
