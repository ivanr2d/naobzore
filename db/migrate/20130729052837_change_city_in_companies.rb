class ChangeCityInCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :city_id
    add_column :companies, :city, :string
  end

  def down
    remove_column :companies, :city
    add_column :companies, :city_id, :integer
  end
end
