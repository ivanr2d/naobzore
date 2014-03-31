# encoding: utf-8

class FillPackages < ActiveRecord::Migration
  def up
    Package.create(:goods_and_services => 250, :jobs => 30, :campaigns => 10, :price => 333, :name => 'Мини')
  end

  def down
    Package.destroy_all
  end
end
