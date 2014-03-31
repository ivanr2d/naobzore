class RemoveSiteFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :site
  end

  def down
    add_column :companies, :site, :string
  end
end
