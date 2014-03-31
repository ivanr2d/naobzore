# encoding: utf-8

class CreateSmsAndCallsWidgets < ActiveRecord::Migration
  def up
    Widget.create(
      :title => 'SMS - рассылка',
      :text => '
        <ul>
          <li><a href="">Отправлено <span class="txt-blue"></span></a></li>
          <li><a href="">Доступно <span class="txt-blue"></span></a></li>
          <li><a href="">База подписчиков</a></li>
          <li><a href="">Купить пакет SMS</a></li>
        </ul>',
      :translit => 'sms'
    )
    Widget.create(
      :title => 'Менеджер звонков',
      :text => '
        <ul>
          <li><a href="">Детализация звонков</a></li>
          <li><a href="">Осталось минут <span class="txt-blue"></span></a></li>
          <li><a href="">Купить пакет минут</a></li>
        </ul>',
      :translit => 'calls'
    )
  end

  def down
    Widget.find_by_translit('sms').try(:destroy)
    Widget.find_by_translit('calls').try(:destroy)
  end
end
