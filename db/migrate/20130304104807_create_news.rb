class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.integer :category_id
      t.text :content
      t.string :anonce
      t.string :image
      t.string :link

      t.timestamps
    end
  end
end
