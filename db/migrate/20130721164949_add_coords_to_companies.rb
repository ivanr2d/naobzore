class AddCoordsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :coords, :string
  end
end
