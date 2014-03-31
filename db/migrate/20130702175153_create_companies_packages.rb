class CreateCompaniesPackages < ActiveRecord::Migration
  def change
    create_table :companies_packages do |t|
      t.integer :company_id, :null => false
      t.integer :package_id, :null => false
      t.datetime :start_at, :null => false
      t.datetime :end_at
      t.boolean :auto, :default => false
    end
  end
end
