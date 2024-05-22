class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks do |t|
      t.string :user_id, null: false
      t.references :spot, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :bookmarks, :user_id
    add_index :bookmarks, [:user_id, :spot_id], unique: true
    add_foreign_key :bookmarks, :users, column: :user_id, primary_key: 'id'
  end
end
