# encoding: utf-8

class FillWidgetTitles < ActiveRecord::Migration
  def up
    Widget.delete_all
    Widget.create(
      :title => 'Баланс <%= current_user.balance %>р.',
      :text => <<-EOF
        <ul>
          <li><a href="">Пополнить</a></li>
          <li><a href="">Акты</a></li>
          <li><a href="">Счета</a></li>
        </ul>
      EOF
    )
    Widget.create(
      :dual => true,
      :title => 'Статистика просмотров'
    )
    Widget.create(
      :title => 'Платные услуги',
      :text => <<-EOF
        <ul>
          <li><a href="">Платные пакеты</a></li>
          <li><a href="">Реклама</a></li>
          <li><a href="">Услуги дизайна</a></li>
          <li><a href="">SMS и телефония</a></li>
        </ul>
      EOF
    )
    Widget.create(
      :title => 'Статус: <span><%= current_user.status %></span>',
      :text => <<-EOF
        <ul>
          <li><a href="">Товаров <span class="txt-blue">50</span> из 200</a></li>
          <li><a href="">Услуг <span class="txt-blue">50</span> из 200</a></li>
          <li><a href="">Вакансий <span class="txt-blue">50</span> из 200</a></li>
          <li><a href="">Акции <span class="txt-blue">5</span></a></li>
        </ul>
      EOF
    )
    Widget.create(
      :title => 'Почта и связь',
      :text => <<-EOF
        <ul>
          <li><a href="">Входящие</a></li>
          <li><a href="">Отправленные</a></li>
          <li><a href="">Отзывы</a></li>
        </ul>
      EOF
    )
    Widget.create(
      :dual => true,
      :title => 'Возможности наОбзоре.рф'
    )
    Widget.create(
      :title => '<span>Информационный блок</span>',
      :text => <<-EOF
        <ul>
          <li><a href="">Новости компании</a></li>
          <li><a href="">Наши акции</a></li>
          <li><a href="">Наши скидки</a></li>
        </ul>
      EOF
    )
    Widget.create(
      :title => 'Добавление',
      :text => <<-EOF
        <ul>
          <li><a href="">Товар</a></li>
          <li><a href="">Услугу</a></li>
          <li><a href="">Вакансию</a></li>
          <li><a href="">Акцию/скидку</a></li>
        </ul>
      EOF
    )
    Widget.create(
      :title => 'Служба поддержки',
      :text => <<-EOF
        <ul>
          <li><a href="#"><img src="images/bell.png" alt="" /></a></li>
          <li>ICQ: <span class="txt-blue">310-234-224</span></li>
          <li>Номер: <span class="txt-blue">8(3532)34-56-65</span></li>
          <li><a href="#" class="blue-button">Написать сообщение</a></li>
        </ul>
      EOF
    )
    Widget.create(
      :title => 'На всякий'
    )
  end

  def down
    Widget.delete_all
  end
end
