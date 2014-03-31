class ChangeCostFieldsInServices < ActiveRecord::Migration
  def up
    rename_column :services, :cost_from, :price
    remove_column :services, :cost_to
  end

  def down
    rename_column :services, :price, :cost_from
    add_column :services, :cost_to, :integer
  end
end
