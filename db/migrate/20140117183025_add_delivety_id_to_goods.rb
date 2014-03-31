class AddDelivetyIdToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :delivety_id, :integer
  end
end
