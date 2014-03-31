# encoding: utf-8

class CreateSettingRegistrationAdvantages < ActiveRecord::Migration
  def up
    Settings.create(:key => :registration_advantages, :title => 'Преимущества регистрации', :value => 'write hear registration advantages')
  end

  def down
  end
end
