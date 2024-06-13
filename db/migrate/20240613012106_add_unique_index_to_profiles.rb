class AddUniqueIndexToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_index :profiles, :user_id, unique: true
  end
end
