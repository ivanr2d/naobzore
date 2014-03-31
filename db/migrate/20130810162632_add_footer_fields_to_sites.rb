class AddFooterFieldsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :footer_text_color, :string
    add_column :sites, :footer_background_color, :string
    add_column :sites, :footer_font, :string
    add_column :sites, :footer_weight, :string
    add_column :sites, :footer_style, :string
  end
end
