class ChangeSiteTypeForCompanies < ActiveRecord::Migration
  def up
    change_column :companies, :site, :string
  end

  def down
    change_column :companies, :site, :integer
  end
end
