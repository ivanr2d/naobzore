class RemoveCharacteristicsFromPriceEntities < ActiveRecord::Migration
  def up
    remove_column :price_entities, :characteristics
  end

  def down
    add_column :prirce_entities, :characteristics, :text
  end
end
