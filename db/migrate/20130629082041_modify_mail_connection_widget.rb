# encoding: utf-8

class ModifyMailConnectionWidget < ActiveRecord::Migration
  def up
    Widget.find_by_translit('mail_connection').try(:update_attribute, :text, '
      <ul>
        <li><a href="">Входящие <span class="txt-blue"><%= current_user.input_messages.unreaded.count %></span></a></li>
        <li><a href="">Отправленные <span class="txt-blue"><%= current_user.output_messages.unreaded.count %></span></a></li>
        <li><a href="">Отзывы</a></li>
      </ul>')
  end

  def down
  end
end
