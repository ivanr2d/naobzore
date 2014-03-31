class AddHeaderImageBackgroundAndTmpHeaderImageBackgroundToSites < ActiveRecord::Migration
  def change
    add_column :sites, :header_image_background, :string
    add_column :sites, :tmp_header_image_background, :string
  end
end
