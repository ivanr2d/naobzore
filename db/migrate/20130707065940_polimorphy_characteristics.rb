class PolimorphyCharacteristics < ActiveRecord::Migration
  def up
    rename_column :characteristics, :good_id, :entity_id
    add_column :characteristics, :entity_type, :string, :limit => 32
    Characteristic.update_all(:entity_type => 'Good')
  end

  def down
    remove_column :characteristics, :entity_type
    rename_column :characteristics, :entity_id, :good_id
  end
end
