class AddPayNdsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :pay_nds, :boolean, :default => false
  end
end
