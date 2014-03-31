# coding: utf-8

ActiveAdmin.register Maker do
  
  menu :label => "Производители", :parent => "Прочее"
  
  filter :name, :label => 'Названию'
  filter :category_name, :label => 'Категории'

  index do
    column "Категория", :category_name
    column "Название", :name
    default_actions
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Категория' do
        maker.category_name
      end 
      row 'Название' do
        maker.name
      end
      row 'Дата добавления' do
        maker.created_at
      end
    end
    active_admin_comments
  end
  
  form do |f|
    f.inputs "Детали товара" do
      f.input :category_id, :label => "Категория ID"
      f.input :category_name, :label => "Категория название"
      f.input :name, :label => "Название"
    end
    f.buttons
  end
  
end