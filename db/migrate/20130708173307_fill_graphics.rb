# encoding: utf-8

class FillGraphics < ActiveRecord::Migration
  def up
    Graphic.create([{:name => 'Пятидневный'}, {:name => 'Два через два'}, {:name => 'Свободный'}])
  end

  def down
    Graphic.destroy_all
  end
end
