class RemoveTableCharacteristics < ActiveRecord::Migration
  def up
    drop_table :characteristics
  end

  def down
    create_table :characteristics do |t|
      t.integer :good_id
      t.string :key, :limit => 64
      t.string :value, :limit => 128

      t.timestamps
    end
  end
end
