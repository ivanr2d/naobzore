class AddColumnTypeToBanners < ActiveRecord::Migration
  def up
    add_column :banners, :banner_type, :string, :limit => 16
    add_column :tutorials, :preview, :string
  end
  
  def down
    remove_column :banners, :banner_type
    remove_column :tutorials, :preview
  end
end
