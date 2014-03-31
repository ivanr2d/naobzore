class AddCatategoryToCompanies < ActiveRecord::Migration
  def up
    add_column :companies, :category_id, :integer
  end
  def down
    remove_column :companies, :category_id
  end
end
