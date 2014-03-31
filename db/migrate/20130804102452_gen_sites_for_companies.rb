# encoding: utf-8

class GenSitesForCompanies < ActiveRecord::Migration
  def up
    Site.create(:company_id => 8, :title => 'Планета', :subdomen => 'planeta')
    Site.create(:company_id => 9, :title => 'Комп-ремонт', :subdomen => 'komp-remont')
  end

  def down
    Site.where(:company_id => [8,9]).destroy_all
  end
end
