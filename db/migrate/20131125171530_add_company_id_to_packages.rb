class AddCompanyIdToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :company_id, :integer
  end
end
