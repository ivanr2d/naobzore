# encoding: utf-8

class FillMenus < ActiveRecord::Migration
  def up
    Menu.create(%w(Главная Товары Услуги Вакансии Отзывы Акции О\ нас Контакты).map { |m| { :name => m } })
  end

  def down
    Menu.destroy_all
  end
end
