class AddCompanyIdToNews < ActiveRecord::Migration
  def change
    add_column :news, :company_id, :integer
  end
end
