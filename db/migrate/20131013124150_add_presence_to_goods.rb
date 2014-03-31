class AddPresenceToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :presence, :string
  end
end
