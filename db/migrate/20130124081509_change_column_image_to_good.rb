class ChangeColumnImageToGood < ActiveRecord::Migration
  def up
    remove_column :goods, :image
    add_column :goods, :images, :integer
  end

  def down
    remove_column :goods, :images
    add_column :goods, :image, :text
  end
end
