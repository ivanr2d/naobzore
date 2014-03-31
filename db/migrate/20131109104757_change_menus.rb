# encoding: utf-8

class ChangeMenus < ActiveRecord::Migration
  def up
    Menu.find_by_name('Отзывы').update_attribute(:name, 'Новости')
    Menu.find_by_name('О нас').update_attribute(:name, 'О компании')

    add_column :menus, :path, :string, :null => false, :after => :name

    { 'Главная' => '/', 'Товары' => '/goods', 'Услуги' => '/services', 'Вакансии' => '/jobs', 'Новости' => '/news', 'Акции' => '/campaigns', 'О компании' => '/about', 'Контакты' => '/contacts' }.each do |name, path|
      ActiveRecord::Base.connection.execute("UPDATE menus SET path = '#{path}' WHERE name = '#{name}'")
    end
  end

  def down
    Menu.find_by_name('Новости').update_attribute(:name, 'Отзывы')
    Menu.find_by_name('О компании').update_attribute(:name, 'О нас')

    remove_column :menus, :path
  end
end
