class ChangePhoneLengthForCompanies < ActiveRecord::Migration
  def up
    change_column :companies, :phone, :string, :limit => 255
  end

  def down
    change_column :companies, :phone, :string, :limit => 24
  end
end
