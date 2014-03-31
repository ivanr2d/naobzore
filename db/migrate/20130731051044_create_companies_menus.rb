class CreateCompaniesMenus < ActiveRecord::Migration
  def change
    create_table :companies_menus do |t|
      t.integer :company_id
      t.integer :menu_id
      t.integer :pos

      t.timestamps
    end
  end
end
