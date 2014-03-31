class RenameTypeInBannerType < ActiveRecord::Migration
  def up
    rename_column :banners, :type, :banner_type
  end

  def down
    rename_column :banners, :banner_type, :type
  end
end
