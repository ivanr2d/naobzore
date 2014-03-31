class RemovePayNdsFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :pay_nds
  end

  def down
    add_column :companies, :pay_nds, :boolean, :default => false
  end
end
