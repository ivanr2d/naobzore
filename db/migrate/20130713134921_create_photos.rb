class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :company_id, :null => false
      t.integer :entity_id
      t.string :entity_type, :limit => 32
      t.string :file, :null => false
      t.integer :size

      t.timestamps
    end
  end
end
