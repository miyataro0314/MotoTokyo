class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :user_id, null: false
      t.string :title, null: false
      t.text :message, null: false
      t.string :url, null: false
      t.integer :notification_type, null: false
      t.integer :priority, null: false, default: 0
      t.boolean :read, null: false, default: false

      t.timestamps
    end

    add_index :notifications, :notification_type
    add_index :notifications, :read
    add_foreign_key :notifications, :users, column: :user_id, primary_key: 'id'
  end
end
