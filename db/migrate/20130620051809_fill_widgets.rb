# encoding: utf-8

class FillWidgets < ActiveRecord::Migration
  def up
    Widget.create(
      :text => <<-EOF
        <div class="title">Баланс 5000р.</div>
        <div class="content">
          <ul>
            <li><a href="">Пополнить</a></li>
            <li><a href="">Акты</a></li>
            <li><a href="">Счета</a></li>
          </ul>
        </div>
      EOF
    )
    Widget.create(
      :dual => true,
      :text => <<-EOF
        <div class="title">График посещаемости</div>
        <div class="content"></div>
      EOF
    )
    Widget.create(
      :text => <<-EOF
        <div class="title">Платные услуги</div>
        <div class="content">
          <ul>
            <li><a href="">Платные пакеты</a></li>
            <li><a href="">Реклама</a></li>
            <li><a href="">Услуги дизайна</a></li>
            <li><a href="">SMS и телефония</a></li>
          </ul>
        </div>
      EOF
    )
    Widget.create(
      :text => <<-EOF
        <div class="title">Статус: <span>заблокирован</span></div>
        <div class="content">
          <ul>
            <li><a href="">Товаров <span class="txt-blue">50</span> из 200</a></li>
            <li><a href="">Услуг <span class="txt-blue">50</span> из 200</a></li>
            <li><a href="">Вакансий <span class="txt-blue">50</span> из 200</a></li>
            <li><a href="">Акции <span class="txt-blue">5</span></a></li>
          </ul>
        </div>
      EOF
    )
    Widget.create(
      :text => <<-EOF
        <div class="title">Почта и связь</div>
        <div class="content">
          <ul>
            <li><a href="">Входящие</a></li>
            <li><a href="">Отправленные</a></li>
            <li><a href="">Отзывы</a></li>
          </ul>
        </div>
      EOF
    )
    Widget.create(
      :dual => true,
      :text => <<-EOF
        <div class="title">Возможности наОбзоре.рф</div>
        <div class="content">
          <!---tu tu tu tu--->
        </div>
      EOF
    )
    Widget.create(
      :text => <<-EOF
          <div class="title"><span>Информационный блок</span></div>
          <div class="content">
            <ul>
              <li><a href="">Новости компании</a></li>
              <li><a href="">Наши акции</a></li>
              <li><a href="">Наши скидки</a></li>
            </ul>
          </div>
      EOF
    )
    Widget.create(
      :text => <<-EOF
        <div class="title">Добавление</div>
        <div class="content">
          <ul>
            <li><a href="">Товар</a></li>
            <li><a href="">Услугу</a></li>
            <li><a href="">Вакансию</a></li>
            <li><a href="">Акцию/скидку</a></li>
          </ul>
        </div>
      EOF
    )
    Widget.create(
      :text => <<-EOF
        <div class="title">Служба поддержки</div>
        <div class="content">
          <ul>
            <li><a href="#"><img src="images/bell.png" alt="" /></a></li>
            <li>ICQ: <span class="txt-blue">310-234-224</span></li>
            <li>Номер: <span class="txt-blue">8(3532)34-56-65</span></li>
            <li><a href="#" class="blue-button">Написать сообщение</a></li>
          </ul>
        </div>
      EOF
    )
    Widget.create(
      :text => <<-EOF
        <div class="title">На всякий</div>
        <div class="content"> </div>
      EOF
    )
  end

  def down
    Widget.delete_all
  end
end
