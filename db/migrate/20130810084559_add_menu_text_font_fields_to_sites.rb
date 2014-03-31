class AddMenuTextFontFieldsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :menu_text_font_family, :string
    add_column :sites, :menu_text_font_weight, :string
    add_column :sites, :menu_text_font_style, :string
  end
end
