class AddWarrantyIdToServices < ActiveRecord::Migration
  def up
    add_column :services, :warranty_id, :integer
    remove_column :services, :warranty_time
    remove_column :services, :warranty_condition
  end

  def down
    remove_column :services, :warranty_id
    add_column :services, :warranty_time, :string, :length => 64
    add_column :services, :warranty_condition, :text
  end
end
