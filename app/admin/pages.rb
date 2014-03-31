# coding: utf-8

ActiveAdmin.register Page do
  
  menu :label => "Статические страницы"
  
  filter :title, :label => 'Заголовок'
  filter :created_at, :label => 'Дата'
  
  index do
    column "Заголовок", :title
    column "Ссылка", :link do |page|
      link_to(page.link, page.link)
    end
    default_actions
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Заголовок' do
        page.title
      end
      row 'Содержимое' do
        page.content
      end
      row 'Ссылка' do
        link_to "#{page.link}", page.link
      end
      row 'Дата добавления' do
        page.created_at
      end
    end
  end
  
  form do |f|
    f.inputs "Детали товара" do
      f.input :title, :label => "Заголовок"
      f.input :content, :label => "Содержимое"
      f.input :link, :label => "Ссылка"
    end
    f.buttons
  end
  
end
