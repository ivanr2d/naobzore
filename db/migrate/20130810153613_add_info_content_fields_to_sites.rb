class AddInfoContentFieldsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :info_content_text_color, :string
    add_column :sites, :info_content_background_color, :string
    add_column :sites, :info_content_font, :string
    add_column :sites, :info_content_weight, :string
    add_column :sites, :info_content_style, :string
  end
end
