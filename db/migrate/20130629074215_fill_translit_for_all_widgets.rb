# encoding: utf-8

class FillTranslitForAllWidgets < ActiveRecord::Migration
  def up
    Widget.where('title like "Баланс%"').first.try(:update_attribute, :translit, 'balance')
    Widget.where('title = "Платные услуги"').first.try(:update_attribute, :translit, 'pay_services')
    Widget.where('title like "Статус:%"').first.try(:update_attribute, :translit, 'user_status')
    Widget.where('title = "Почта и связь"').first.try(:update_attribute, :translit, 'mail_connection')
    Widget.where('title like "%Информационный блок%"').first.try(:update_attribute, :translit, 'information')
    Widget.where('title = "Добавление"').first.try(:update_attribute, :translit, 'addind')
    Widget.where('title = "На всякий"').first.try(:update_attribute, :translit, 'reserve')
  end

  def down
  end
end
