class CreateEntityImages < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.integer  :entity_id, :null => false, :limit => 8
      t.integer  :category_id, :limit => 8
      t.string  :entity_type, :null => false, :limit => 32
      t.string   :url, :null => false, :limit => 255

      t.timestamps
    end
  end

  def down
    drop_table :images
  end
end
