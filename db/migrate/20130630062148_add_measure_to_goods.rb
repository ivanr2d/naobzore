class AddMeasureToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :measure, :string, :limit => 10, :after => :price
  end
end
