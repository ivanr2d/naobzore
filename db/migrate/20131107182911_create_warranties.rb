class CreateWarranties < ActiveRecord::Migration
  def change
    create_table :warranties do |t|
      t.string :code, :null => false
      t.text :conditions, :null => false
      t.boolean :default, :default => false
      t.integer :company_id, :null => false

      t.timestamps
    end
  end
end
