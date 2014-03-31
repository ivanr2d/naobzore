class AddWarrantyIdToGoods < ActiveRecord::Migration
  def up
    add_column :goods, :warranty_id, :integer
    remove_column :goods, :warranty_time
    remove_column :goods, :warranty_condition
  end

  def down
    remove_column :goods, :warranty_id
    add_column :goods, :warranty_time, :string, :length => 64
    add_column :goods, :warranty_condition, :text
  end
end
