class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices, :options => 'AUTO_INCREMENT=10000' do |t|
      t.integer :sum, :null => false
      t.integer :company_id, :null => false

      t.timestamps
    end
  end
end
