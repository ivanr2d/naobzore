class CreateFactures < ActiveRecord::Migration
  def change
    create_table :factures, :options => 'AUTO_INCREMENT=10000' do |t|
      t.integer :company_id, :null => false
      t.integer :act_id
      t.integer :sum, :null => false
      t.integer :entity_id
      t.string :entity_type

      t.timestamps
    end
  end
end
