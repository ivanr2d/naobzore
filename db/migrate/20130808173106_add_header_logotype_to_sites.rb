class AddHeaderLogotypeToSites < ActiveRecord::Migration
  def change
    add_column :sites, :header_logotype, :string
  end
end
