class CreateAccessHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :access_histories do |t|
      t.string :user_id, null: false
      t.references :spot, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :access_histories, :user_id
    add_foreign_key :access_histories, :users, column: :user_id, primary_key: 'id'
  end
end
