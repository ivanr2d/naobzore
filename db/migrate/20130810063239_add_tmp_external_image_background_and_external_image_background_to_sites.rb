class AddTmpExternalImageBackgroundAndExternalImageBackgroundToSites < ActiveRecord::Migration
  def change
    add_column :sites, :tmp_external_image_background, :string
    add_column :sites, :external_image_background, :string
  end
end
