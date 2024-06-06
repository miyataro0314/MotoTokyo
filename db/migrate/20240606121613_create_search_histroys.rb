class CreateSearchHistroys < ActiveRecord::Migration[7.1]
  def change
    create_table :search_histories do |t|
      t.string :user_id, null: false
      t.integer :search_query
      t.integer :parking
      t.integer :category
      t.integer :area

      t.timestamps
    end

    add_index :search_histories, :user_id
    add_foreign_key :search_histories, :users, column: :user_id, primary_key: 'id'
  end
end
