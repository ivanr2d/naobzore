class RemoveAddressFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :address
  end

  def down
    add_column :companies, :address, :string
  end
end
