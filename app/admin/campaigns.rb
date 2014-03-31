# coding: utf-8

ActiveAdmin.register Campaign do
  # XXX move to module
  before_filter do
    Campaign.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  member_action :unpublish, :method => :put do
    campaign = Campaign.find(params[:id])
    campaign.update_attribute(:published, false)
    Message.create(:text => "Акция \"#{campaign.name}\" снята с публикации", :from_id => Company.main.id, :to_id => campaign.company_id)
    redirect_to admin_campaigns_path, :notice => 'Заблокировано'
  end

  menu :label => "Акции", :parent => "Управление контентом"
  
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
    column "Текст", :description
    actions do |campaign|
      link_to 'Заблокировать', unpublish_admin_campaign_path(campaign), :method => :put, :confirm => 'Заблокировать?'
    end
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Компания' do
        campaign.company
      end
      row 'Категория' do
        campaign.category
      end 
      row 'Название' do
        campaign.name
      end
      row 'Текст' do
        campaign.description
      end
      row 'Дата добавления' do
        campaign.created_at
      end
    end
    active_admin_comments
  end
  
  status = {
    :Неактивена => 0,
    :Активена => 1
  }
  form do |f|
    f.inputs "Детали товара" do
      f.input :category, :label => "Категория"
      f.input :company, :label => "Компания"
      f.input :name, :label => "Название"
      f.input :description, :label => "Текст"
      f.input :status, :label => "Статус", :as => :radio, :collection => status
    end
    f.buttons
  end
  
end
