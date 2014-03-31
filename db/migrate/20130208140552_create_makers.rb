class CreateMakers < ActiveRecord::Migration
  def change
    create_table :makers do |t|
      t.string :name, :limit => 64
      t.integer :category_id
      t.string :category_name, :limit => 64

      t.timestamps
    end
  end
end