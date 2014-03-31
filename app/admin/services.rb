# coding: utf-8

ActiveAdmin.register Service do
  before_filter do
    Service.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  member_action :unpublish, :method => :put do
    service = Service.find(params[:id])
    service.update_attribute(:published, false)
    Message.create(:text => "Акция \"#{service.name}\" снята с публикации", :from_id => Company.main.id, :to_id => service.company_id)
    redirect_to admin_services_path, :notice => 'Заблокировано'
  end
  
  menu :label => "Услуги", :parent => "Управление контентом"
  
  filter :category, :label => 'Категории'
  filter :company, :label => 'Компании'
  filter :name, :label => 'Названию'
  filter :salary_from, :label => 'Зарплата от'
  filter :salary_to, :label => 'Зарплата до'
  filter :created_at, :label => 'Дата'

  index do
    column "Категория", :category
    column "Компания", :company
    column "Название", :name
    column "Описание", :description
    actions do |service|
      link_to 'Заблокировать', unpublish_admin_service_path(service), :method => :put, :confirm => 'Заблокировать?'
    end
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Изображение' do
        image_tag(service.image, :width => 150, :height => 150)
      end
      row 'Компания' do
        service.company
      end
      row 'Категория' do
        service.category
      end 
      row 'Название' do
        service.name
      end
      row 'Описание' do
        service.description
      end
      row 'Цена' do
        service.price
      end
      row 'Дата добавления' do
        service.created_at
      end
    end
    active_admin_comments
  end
  
  form do |f|
    f.inputs "Детали товара" do
      f.input :image, :label => "Изображение", :as => 'file'
      f.input :category, :label => "Категория"
      f.input :company, :label => "Компания"
      f.input :name, :label => "Название"
      f.input :description, :label => "Описание"
      f.input :campaign, :label => 'Акция'
      #Изменяется размер поля
      f.input :price, :label => "Цена", :input_html => { :size => 10, :style => 'max-width: 100px;' }
    end
    f.buttons
  end
  
end
