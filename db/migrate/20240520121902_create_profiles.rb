class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :user_id, null: false
      t.string :user_name
      t.string :vehicle_name
      t.integer :vehicle_type

      t.timestamps
    end

    add_foreign_key :profiles, :users, column: :user_id, primary_key: 'id'
  end
end
