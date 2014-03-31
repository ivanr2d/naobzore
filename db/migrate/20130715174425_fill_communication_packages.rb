# encoding: utf-8

class FillCommunicationPackages < ActiveRecord::Migration
  def up
    Package.create(:name => 'Мини', :ptype => :communication, :sms => 400, :price => 200)
    Package.create(:name => 'Стандарт', :ptype => :communication, :sms => 700, :price => 300)
    Package.create(:name => 'Макси', :ptype => :communication, :sms => 1000, :price => 400)
  end

  def down
    Package.where(:ptype => :communication).destroy_all
  end
end
