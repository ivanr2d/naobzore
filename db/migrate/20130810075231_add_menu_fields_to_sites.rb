class AddMenuFieldsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :menu_text_color, :string
    add_column :sites, :menu_text_hover_color, :string
    add_column :sites, :menu_background_color, :string
    add_column :sites, :menu_background_hover_color, :string
  end
end
