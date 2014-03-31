# coding: utf-8

ActiveAdmin.register Settings do
  menu false
  config.filters = false

  #especified :new

  index do
    column :key
    column :value
    column :file do |settings|
      link_to File.basename(settings.file_url), settings.file_url, :target => :_blank if settings.file_url.present?
    end
    column :title
    default_actions
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row :key do
        settings.key
      end
      row :value do
        settings.value
      end
      row :file do
        file_tag settings.file_url if settings.file_url.present?
      end
      row :title do
        settings.title
      end
    end
  end
  
  cat_types = {
    :Товары => 1,
    :Услуги => 2
  }
  
  form do |f|
    f.inputs "Детали настройки" do
      f.input :key
      f.input :value
      f.input :image, :as => :file
      f.input :title
    end
    f.buttons
  end
                 
end
