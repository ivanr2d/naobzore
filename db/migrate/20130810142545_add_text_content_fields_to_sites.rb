class AddTextContentFieldsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :text_content_color, :string
    add_column :sites, :text_content_font, :string
    add_column :sites, :text_content_weight, :string
    add_column :sites, :text_content_style, :string
  end
end
