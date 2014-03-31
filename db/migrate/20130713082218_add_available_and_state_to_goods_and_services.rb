class AddAvailableAndStateToGoodsAndServices < ActiveRecord::Migration
  def change
    add_column :goods, :available, :boolean, :default => true
    add_column :goods, :state, :string
    add_column :services, :available, :boolean, :default => true
    add_column :services, :state, :string
  end
end
