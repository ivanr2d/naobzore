class AddFromApsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :from_aps, :boolean, :default => false
  end
end
