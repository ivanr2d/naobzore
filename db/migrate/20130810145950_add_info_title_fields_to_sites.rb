class AddInfoTitleFieldsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :info_title_text_color, :string
    add_column :sites, :info_title_background_color, :string
    add_column :sites, :info_title_font, :string
    add_column :sites, :info_title_weight, :string
    add_column :sites, :info_title_style, :string
  end
end
