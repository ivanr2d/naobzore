# encoding: utf-8

class AddTranslitToWidgets < ActiveRecord::Migration
  def up
    add_column :widgets, :translit, :string, :limit => 100, :after => :text
    Widget.find_by_title('Статистика просмотров').try(:update_attribute, :translit, 'view_statistics')
  end

  def down
    remove_column :widgets, :translit
  end
end
