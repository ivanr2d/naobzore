# coding: utf-8

ActiveAdmin.register Good do
  before_filter do
    Good.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  member_action :unpublish, :method => :put do
    good = Good.find(params[:id])
    good.update_attribute(:published, false)
    Message.create(:text => "Акция \"#{good.name}\" снята с публикации", :from_id => Company.main.id, :to_id => good.company_id)
    redirect_to admin_goods_path, :notice => 'Заблокировано'
  end

  scope :all, :default => true
  menu :label => "Товары", :parent => "Управление контентом"
  
  config.per_page = 10
  
  filter :category, :label => 'Категории'
  filter :company, :label => 'Компании'
  filter :name, :label => 'Названию'
  filter :created_at, :label => 'Дата'
  
  index do
    column "Категория", :category
    column "Компания", :company
    column "Название", :name
    column "Описание", :description
    column "Цена", :price
    actions do |good|
      link_to 'Заблокировать', unpublish_admin_good_path(good), :method => :put, :confirm => 'Заблокировать?'
    end
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Изображение' do
        image_tag(good.image, :width => 150, :height => 150)
      end
      row 'Компания' do
        good.company
      end
      row 'Категория' do
        good.category
      end 
      row 'Название' do
        good.name
      end
      row 'Цена' do
        good.price
      end
      row 'Описание' do
        good.description
      end
      row 'Дата добавления' do
        good.created_at
      end
      row 'Картинки' do
        render "images", :good => good
      end
    end
    active_admin_comments
  end
  
  #form :partial => "form"
  
  form :html => { :enctype => "multipart/form-data" } do |f|
      f.inputs "Детали товара" do
        f.input :image, :label => 'Главное изображение', :as => 'file'
        f.input :name, :label => 'Название'
        f.input :category, :label => 'Категория'
        f.input :company, :label => 'Компания'
        f.input :description, :label => 'Описание'
        f.input :characteristics, :label => 'Характеристики'
        f.input :price, :label => 'Цена'
        f.input :maker, :label => 'Производитель'
        f.input :campaign, :label => 'Акция'
        #f.input :images, :hint=>"<a href=\"/admin/images?q[entity_id_eq]=#{good.id}&q[entity_type_eq]=good\">Управление картинками</a>".html_safe, :label => 'Картинки', :as => 'select'
        f.input :is_spec, :label => 'Специальное предложение', :as => :boolean
      end
    f.buttons
  end
  
end
