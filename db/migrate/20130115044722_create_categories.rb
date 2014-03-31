class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :parent_id, :null => false, :limit => 8
      t.string :title, :null => false, :limit => 128
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
