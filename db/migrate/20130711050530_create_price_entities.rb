class CreatePriceEntities < ActiveRecord::Migration
  def change
    create_table :price_entities do |t|
      t.integer :article
      t.string :name, :null => false
      t.integer :category_id
      t.text :description
      t.text :characteristics
      t.integer :price
      t.string :measure, :limit => 10
      t.string :image
      t.boolean :available, :default => true
      t.string :state
      t.string :maker
      t.integer :folder_id
      t.string :warranty_time
      t.integer :company_id, :null => false
      t.integer :price_list_id, :null => false

      t.timestamps
    end
  end
end
