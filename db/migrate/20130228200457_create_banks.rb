class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.integer :company_id
      t.string :logotype
      t.string :name
      t.text :condition
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
