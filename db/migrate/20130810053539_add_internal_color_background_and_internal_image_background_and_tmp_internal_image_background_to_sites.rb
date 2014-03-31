class AddInternalColorBackgroundAndInternalImageBackgroundAndTmpInternalImageBackgroundToSites < ActiveRecord::Migration
  def change
    add_column :sites, :internal_color_background, :string
    add_column :sites, :external_color_background, :string
  end
end
