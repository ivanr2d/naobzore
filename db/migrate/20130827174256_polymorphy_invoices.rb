class PolymorphyInvoices < ActiveRecord::Migration
  def up
    remove_column :invoices, :itype
    add_column :invoices, :entity_type, :string
    add_column :invoices, :entity_id, :integer
  end

  def down
    remove_column :invoices, :entity_type
    remove_column :invoices, :entity_id
    add_column :invoices, :itype, :enum, :limit => [:fill, :banner, :package], :null => false
  end
end
