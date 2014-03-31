# encoding: utf-8

class CreateSupportSettings < ActiveRecord::Migration
  def up
    Settings.create [{
      :key => 'support_icq',
      :title => 'ICQ службы поддержки',
      :value => 310234224
    }, {
      :key => 'support_phone',
      :title => 'Телефон службы поддержки',
      :value => 83532345665
    }]
  end

  def down
    Settings.where(:key => [:support_icq, :support_phone]).destroy_all
  end
end
