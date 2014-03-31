class AddBalanceToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :balance, :float, :default => 0
  end
end
