# encoding: utf-8

class CreateMinisiteLogotypeSetting < ActiveRecord::Migration
  def up
    Settings.create(:key => 'minisite_logotype', :title => 'Логотип минисайта', :file => File.open(File.join(Rails.root, 'public/miniSite/images/temp/logo_kepler.png')))
  end

  def down
    Settings.find_by_key('minisite_logotype').try(:destroy)
  end
end
