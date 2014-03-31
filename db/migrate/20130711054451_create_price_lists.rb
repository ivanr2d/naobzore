class CreatePriceLists < ActiveRecord::Migration
  def change
    create_table :price_lists do |t|
      t.enum :note_missed_entities, :limit => [:no, :unpublished, :deleted], :default => :no
      t.string :refreshed_fields
      t.integer :company_id, :null => false
      t.string :xls, :null => false

      t.timestamps
    end
  end
end
