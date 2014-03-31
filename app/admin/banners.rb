# coding: utf-8

ActiveAdmin.register Banner do
  menu false
  
  filter :created_at, :label => 'Дата'

  index do
    column "Баннер", :banner do |banner|
      image_tag(banner.banner, :height => '100')
    end
    column "Заголовок", :title
    column "Ссылка", :link do |banner|
      link_to(banner.link, banner.link)
    end
    default_actions
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Баннер' do
        #Вывод логотипа
        image_tag(banner.banner, :height => '175')
      end
      row 'Заголовок' do
        banner.title
      end
      row 'Ссылка' do
        link_to "#{banner.link}", banner.link
      end
      row 'Место' do
        #(banner.place) ? "Второстепенная" : "Главная"
      end
    end
    active_admin_comments
  end
  
  places = {
    :Главная => 0,
    :Товары => 1,
    :Услуги => 2,
  }
  
  types = Common.types << ['Главная', 'Home']
  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Детали баннера" do 
      #Меняем тип ввода на загрузку файлов
      f.input :banner, :label => "Баннер", :as => :file
      f.input :link, :label => "Ссылка"
      f.input :title, :label => "Заголовок"
      f.input :banner_type, :label => "Место", :as => :select, :collection => types
      f.input :week
      f.input :link
    end
    f.buttons
  end

end
