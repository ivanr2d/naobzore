class CreateSubdomains < ActiveRecord::Migration
  def change
    create_table :subdomains do |t|
      t.string :name
      t.integer :company_id

      t.timestamps
    end
  end
end
