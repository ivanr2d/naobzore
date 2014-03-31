class AddTextTitleFieldsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :text_title_color, :string
    add_column :sites, :text_title_font_family, :string
    add_column :sites, :text_title_font_weight, :string
    add_column :sites, :text_title_font_style, :string
  end
end
