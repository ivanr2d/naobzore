class ChangeFaxLimitForCompanies < ActiveRecord::Migration
  def up
    change_column :companies, :fax, :string, :limit => 255
  end

  def down
    change_column :companies, :fax, :string, :limit => 32
  end
end
