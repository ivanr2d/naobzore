class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.integer :company_id, :null => false, :limit => 8
      t.string :title, :null => false, :limit => 128
      t.string :subdomen, :null => false, :limit => 64
      t.text :menu_items
      t.string :contacts
      t.string :color
      t.string :template

      t.timestamps
    end
  end
end
