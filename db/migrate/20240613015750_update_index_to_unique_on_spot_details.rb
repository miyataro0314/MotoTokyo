class UpdateIndexToUniqueOnSpotDetails < ActiveRecord::Migration[7.1]
  def up
    remove_index :spot_details, :spot_id if index_exists?(:spot_details, :spot_id)
    add_index :spot_details, :spot_id, unique: true
  end

  def down
    remove_index :spot_details, :spot_id if index_exists?(:spot_details, :spot_id)
    add_index :spot_details, :spot_id
  end
end
