class CreateEditHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :edit_histories do |t|
      t.string :user_id, null: false
      t.references :spot, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :edit_histories, :user_id
    add_index :edit_histories, [:user_id, :spot_id], unique: true
    add_foreign_key :edit_histories, :users, column: :user_id, primary_key: 'id'
  end
end
