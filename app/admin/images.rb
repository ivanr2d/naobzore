# coding: utf-8

ActiveAdmin.register Image do
  
  #menu :label => "Изображения"
  menu false

  config.filters = false

  #especified :new
  
  collection_action :new_m, :method => :get do
    render "form"
  end

  index do
    selectable_column
    column "URL", :url
    default_actions
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'URL' do
        image.url
      end
    end
    active_admin_comments
  end
  
  cat_types = {
    :Товары => 1,
    :Услуги => 2
  }
  
  form do |f|
    f.inputs "Детали товара" do
      f.input :entity_id, :label => "Сущность"
      f.input :url, :label => "URL", :as => 'file'
    end
    f.buttons
  end
                 
end