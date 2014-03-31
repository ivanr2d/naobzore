# encoding: utf-8

class AddTranslitForSupportWidget < ActiveRecord::Migration
  def up
    Widget.find_by_title('Служба поддержки').try(:update_attribute, :translit, 'support_service')
  end

  def down
    Widget.find_by_title('Служба поддержки').try(:update_attribute, :translit, nil)
  end
end
