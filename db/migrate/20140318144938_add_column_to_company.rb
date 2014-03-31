class AddColumnToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :ur_index, :string
    add_column :companies, :ur_city, :string
    add_column :companies, :ur_street, :string
    add_column :companies, :ur_home, :string
    add_column :companies, :ur_corp, :string
    add_column :companies, :ur_office, :string
  end
end
