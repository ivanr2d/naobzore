class SetMainForCompanyNaobzore < ActiveRecord::Migration
  def up
    Company.find_by_name('naobzore').try(:update_attribute, :main, true)
  end

  def down
    Company.find_by_name('naobzore').try(:update_attribute, :main, false)
  end
end
