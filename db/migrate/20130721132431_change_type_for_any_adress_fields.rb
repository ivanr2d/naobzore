class ChangeTypeForAnyAdressFields < ActiveRecord::Migration
  def change
    change_column :companies, :house, :string
    change_column :companies, :building, :string
    change_column :companies, :office, :string
  end
end
