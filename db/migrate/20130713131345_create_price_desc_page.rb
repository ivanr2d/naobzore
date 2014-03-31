# encoding: utf-8

class CreatePriceDescPage < ActiveRecord::Migration
  def up
    Page.create(:title => 'Описание загрузки прайс-листа', :link => 'price_desc', :content => '
      <div class="info">
        Импортируйте описание товаров и услуг в кабинет компании и опубликуйте весь 
        ассортимент ваших товаров и услуг всего за несколько минут! Здесь вы можете выполнить импорт 
        позиций из наиболее популярных форматов файлов «.xls» и «.csv».
      </div>'
    )
  end

  def down
    Page.find_by_link('price_desc').try(:destroy)
  end
end
