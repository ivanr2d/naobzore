class FillStatusForCompanies < ActiveRecord::Migration
  def up
    Company.update_all(:status => :active)
  end

  def down
    Company.update_all(:status => :activation)
  end
end
