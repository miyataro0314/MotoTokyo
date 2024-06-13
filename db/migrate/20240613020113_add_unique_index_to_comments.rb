class AddUniqueIndexToComments < ActiveRecord::Migration[7.1]
  def change
    add_index :comments, [:user_id, :spot_id], unique: true
  end
end
