class AddHeaderColorBackgroundToSites < ActiveRecord::Migration
  def change
    add_column :sites, :header_color_background, :string, :limit => 10
  end
end
