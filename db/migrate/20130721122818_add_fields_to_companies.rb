class AddFieldsToCompanies < ActiveRecord::Migration
  def change
    change_table :companies do |t|
      t.integer :post_index
      t.integer :city_id
      t.string :street
      t.integer :house
      t.integer :building
      t.integer :office
      t.string :address_comment
      t.string :email
      t.string :skype
      t.integer :icq
      t.integer :creation_year
      t.text :short_description
    end
  end
end
