# coding: utf-8

class AddOptionDeliveryToSettings < ActiveRecord::Migration
  def up
      Settings.create! do |r|
        r.key   = 'delivery'
        r.value = 0
        r.title = 'Доставка'
      end
  end
  
  def down
    Settings.find_by_key('delivery').try(:delete)
  end
end
