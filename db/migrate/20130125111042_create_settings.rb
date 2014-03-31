class CreateSettings < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end
  
  def down
    drop_table :settings
  end
end
