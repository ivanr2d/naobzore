class CreateActs < ActiveRecord::Migration
  def change
    create_table :acts, :options => 'AUTO_INCREMENT=10000' do |t|
      t.integer :company_id, :null => false
      t.integer :sum, :null => false
      t.string :entity_type
      t.integer :entity_id

      t.timestamps
    end
  end
end
