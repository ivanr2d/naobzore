class AddSiteAddressToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :site_address, :string
  end
end
