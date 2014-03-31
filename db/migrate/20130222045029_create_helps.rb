class CreateHelps < ActiveRecord::Migration
  def change
    create_table :helps do |t|
      t.string :title, :null => false
      t.string :alias, :null => false
      t.integer :category_id, :null => false
      t.text :text

      t.timestamps
    end
  end
end