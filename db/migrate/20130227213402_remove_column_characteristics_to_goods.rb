class RemoveColumnCharacteristicsToGoods < ActiveRecord::Migration
  def up
    remove_column :goods, :characteristics
  end

  def down
    add_column :goods, :characteristics, :string
  end
end
