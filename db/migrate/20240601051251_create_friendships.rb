class CreateFriendships < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.string :user_id, null: false
      t.string :friend_id, null: false
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :friendships, :user_id
    add_index :friendships, :friend_id
    add_index :friendships, [:user_id, :friend_id], unique: true
    add_foreign_key :friendships, :users, column: :user_id, primary_key: 'id'
    add_foreign_key :friendships, :users, column: :friend_id, primary_key: 'id'
  end
end
