class AddFaviconToSite < ActiveRecord::Migration
  def change
    add_column :sites, :favicon, :string
  end
end
