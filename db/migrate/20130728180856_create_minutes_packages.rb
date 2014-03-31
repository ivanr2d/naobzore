# encoding: utf-8

class CreateMinutesPackages < ActiveRecord::Migration
  def up
    Package.create([
      {:name => 'Базовый', :ptype => :minutes, :calls => 100, :price => 250},
      {:name => 'Универсальный', :ptype => :minutes, :calls => 250, :price => 600},
      {:name => 'Максимальный', :ptype => :minutes, :calls => 500, :price => 1100}
    ])
  end

  def down
    Package.where(:ptype => :minutes).destroy_all
  end
end
