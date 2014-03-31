# coding: utf-8

ActiveAdmin.register Dimensionw do
  
  menu :label => "Единицы измерения", :parent => "Прочее"
  
  filter :name, :label => 'Название'

  index do
    column "Название", :name
    default_actions
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Название' do
        dimensionw.name
      end
    end
  end
  
  form do |f|
    f.inputs "Детали" do
      f.input :name, :label => "Название"
    end
    f.buttons
  end
  
end
