class AddNullFalseToProfiles < ActiveRecord::Migration[7.1]
  def change
    change_column_null :profiles, :user_name, false
  end
end
