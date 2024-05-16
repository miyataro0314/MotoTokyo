class CreateSpots < ActiveRecord::Migration[7.1]
  def change
    create_table :spots do |t|
      t.string :user_id, null: false
      t.string :name, null: false
      t.integer :parking, null: false
      t.integer :parking_limitation, null: false
      t.integer :category, null: false
      t.integer :area, null: false
      
      t.timestamps
    end

    add_index :spots, :user_id
    add_foreign_key :spots, :users, column: :user_id, primary_key: 'id'
    
    add_index :spots, :name, unique: true
    add_index :spots, :category
    add_index :spots, :area
  end
end
