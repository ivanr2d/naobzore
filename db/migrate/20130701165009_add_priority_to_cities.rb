# encoding: utf-8

class AddPriorityToCities < ActiveRecord::Migration
  def up
    add_column :cities, :priority, :integer, :default => 0
    City.find_by_name('Оренбург').update_attribute(:priority, 2)
    City.find_by_name('Орск').update_attribute(:priority, 1)
  end

  def down
    remove_column :cities, :priority
  end
end
