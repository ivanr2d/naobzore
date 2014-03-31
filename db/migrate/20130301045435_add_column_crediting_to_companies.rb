class AddColumnCreditingToCompanies < ActiveRecord::Migration
  def up
    add_column :companies, :crediting, :text
    add_column :goods, :warranty_time, :string, :limit => 64
    add_column :goods, :warranty_condition, :text
    add_column :services, :warranty_time, :string, :limit => 64
    add_column :services, :warranty_condition, :text
  end
  
  def down
    remove_column :companies, :crediting
    remove_column :goods, :warranty_time
    remove_column :goods, :warranty_condition
    remove_column :services, :warranty_time
    remove_column :services, :warranty_condition
  end
end