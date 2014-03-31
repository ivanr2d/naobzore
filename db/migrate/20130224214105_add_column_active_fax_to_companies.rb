class AddColumnActiveFaxToCompanies < ActiveRecord::Migration
  def up
    add_column :companies, :active, :integer, :limit => 1
    add_column :companies, :fax, :string, :limit => 32
    add_column :companies, :inn, :string, :limit => 32
    add_column :companies, :ogrn, :string, :limit => 32
    add_column :companies, :site, :integer
    add_column :companies, :com_type, :integer
  end

  def down
    remove_column :companies, :active
    remove_column :companies, :fax
    remove_column :companies, :inn
    remove_column :companies, :ogrn
    remove_column :companies, :site
    remove_column :companies, :com_type
  end
end
