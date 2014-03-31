# encoding: utf-8

class UseSettingsInSupportServiceWidget < ActiveRecord::Migration
  def up
    Widget.find_by_translit('support_service').update_attribute(:text, '
      <ul>
        <li><a href="#"><img src="/controlPanel/images/bell.png" alt="" /></a></li>
        <li>ICQ: <span class="txt-blue"><%= number_with_delimiter(Settings.find_by_key(:support_icq).value, :delimmiter => "-") %></span></li>
        <li>Номер: <span class="txt-blue"><%= number_to_phone(Settings.find_by_key(:support_phone).value) %></span></li>
        <li><a href="#" class="blue-button">Написать сообщение</a></li>
      </ul>
    ')
  end

  def down
  end
end
