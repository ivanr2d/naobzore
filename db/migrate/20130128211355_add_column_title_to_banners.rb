class AddColumnTitleToBanners < ActiveRecord::Migration
  def up
    add_column :banners, :title, :string
  end
  def down
    remove_column :banners, :title
  end
end
