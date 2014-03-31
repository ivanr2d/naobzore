class AllowNullForPriceEntitiesName < ActiveRecord::Migration
  def up
    change_column :price_entities, :name, :string, :null => true
  end

  def down
    change_column :price_entities, :name, :string, :null => false
  end
end
