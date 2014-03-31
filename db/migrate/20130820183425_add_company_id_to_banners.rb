class AddCompanyIdToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :company_id, :integer, :null => false
  end
end
