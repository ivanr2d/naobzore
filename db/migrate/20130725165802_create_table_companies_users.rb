class CreateTableCompaniesUsers < ActiveRecord::Migration
  def up
    create_table :companies_users do |t|
      t.integer :company_id, :null => false
      t.integer :user_id, :null => false
    end
  end

  def down
    remove_table :companies_users
  end
end
