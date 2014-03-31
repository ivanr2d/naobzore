# encoding: utf-8

class FillPlacingPackages < ActiveRecord::Migration
  def up
    [{:name => 'Мини', :goods_and_services => 25, :jobs => 10, :campaigns => 10, :price => 333},
    {:name => 'Стандарт', :goods_and_services => 100, :jobs => 30, :campaigns => 30, :price => 666},
    {:name => 'Макси', :goods_and_services => 500, :jobs => 100, :campaigns => 100, :price => 999}].each do |p|
      package = Package.find_or_initialize_by_name_and_ptype p[:name], :placing
      package.goods_and_services = p[:goods_and_services]
      package.jobs = p[:jobs]
      package.campaigns = p[:campaigns]
      package.price = p[:price]
      package.save
    end
  end

  def down
  end
end
