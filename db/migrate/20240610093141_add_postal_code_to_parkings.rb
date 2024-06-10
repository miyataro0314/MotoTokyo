class AddPostalCodeToParkings < ActiveRecord::Migration[7.1]
  def change
    add_column :parkings, :postal_code, :string 
  end
end
