class CreateVisits < ActiveRecord::Migration
  def up
    create_table :visits do |t|
      t.integer  :entity_id, :null => false, :limit => 8
      t.string  :entity_type, :null => false, :limit => 32
      t.string   :ip, :null => false, :limit => 255

      t.timestamps
    end
  end

  def down
    drop_table :visits
  end
end
