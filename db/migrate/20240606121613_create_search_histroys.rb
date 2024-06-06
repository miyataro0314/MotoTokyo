class CreateSearchHistroys < ActiveRecord::Migration[7.1]
  def change
    create_table :search_histories do |t|
      t.string :user_id, null: false
      t.integer :area, null: false
      t.integer :category, null: false

      t.timestamps
    end

    add_index :search_histories, :user_id
    add_index :search_histories, :area
    add_index :search_histories, :category
    add_foreign_key :search_histories, :users, column: :user_id, primary_key: 'id'
  end
end
