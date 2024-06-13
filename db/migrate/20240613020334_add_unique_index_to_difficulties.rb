class AddUniqueIndexToDifficulties < ActiveRecord::Migration[7.1]
  def change
    add_index :difficulties, [:user_id, :spot_id], unique: true
  end
end
