class AddTypeAndStatusToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :itype, :enum, :limit => [:fill, :banner, :package], :null => false
    add_column :invoices, :status, :enum, :limit => [:process, :complete, :cancel], :default => :process
  end
end
