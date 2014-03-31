class AddIndexOnCreatedAtToInvoicesFacturesActs < ActiveRecord::Migration
  def change
    [:invoices, :factures, :acts].each do |table|
      add_index table, :created_at
    end
  end
end
