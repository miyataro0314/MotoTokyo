class CreateDifficulties < ActiveRecord::Migration[7.1]
  def change
    create_table :difficulties do |t|
      t.string :user_id, null: false
      t.references :spot, null: false, foreign_key: true
      t.integer :level, null: false

      t.timestamps
    end

    add_index :difficulties, :user_id
    add_foreign_key :difficulties, :users, column: :user_id, primary_key: 'id'
  end
end
