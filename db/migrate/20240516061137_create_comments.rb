class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.string :user_id, null: false
      t.references :spot, null: false, foreign_key: true, index: true
      t.text :content, null: false

      t.timestamps
    end

    add_foreign_key :comments, :users, column: :user_id, primary_key: 'id'
  end
end
