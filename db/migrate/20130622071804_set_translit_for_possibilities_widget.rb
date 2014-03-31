# encoding: utf-8

class SetTranslitForPossibilitiesWidget < ActiveRecord::Migration
  def up
    Widget.find_by_title('Возможности наОбзоре.рф').try(:update_attribute, :translit, 'possibilities')
  end

  def down
    Widget.find_by_title('Возможности наОбзоре.рф').try(:update_attribute, :translit, nil)
  end
end
