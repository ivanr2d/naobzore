class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :pos, :null => false, :default => 0
      t.boolean :dual, :default => false
      t.text :text
      t.timestamps
    end
    add_index :widgets, :pos
  end
end
