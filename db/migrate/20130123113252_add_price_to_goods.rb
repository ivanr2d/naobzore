class AddPriceToGoods < ActiveRecord::Migration
  def up
    add_column :goods, :price, :integer
  end
  def down
    remove_column :goods, :price
  end
end
