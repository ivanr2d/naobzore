class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.integer :category_id, :null => false, :limit => 8
      t.integer :company_id, :null => false, :limit => 8
      t.string :title, :null => false, :limit => 128
      t.text :description
      t.text :image

      t.timestamps
    end
  end
end
