class AddTmpLogotypeToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :tmp_logotype, :string
  end
end
