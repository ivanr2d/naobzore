# coding: utf-8

ActiveAdmin.register Company do
  before_filter lambda { @company = Company.find params[:id] }, :only => [:activate, :lock]

  member_action :activate, :method => :put do
    @company.update_attribute(:status, :active)
    redirect_to admin_companies_path, :notice => 'Активировано'
  end

  member_action :lock, :method => :put do
    @company.update_attribute(:status, :locked)
    redirect_to admin_companies_path, :notice => 'Заблокировано'
  end

  menu :label => "Компании", :priority => 0, :parent => 'Пользователи'
  
  
  filter :user, :label => 'Пользователь'
  filter :legal_name, :label => 'Название'
  filter :phone, :label => 'Телефон'
  filter :created_at, :label => 'Дата'

  index do
    column "Название", :legal_name
    column "Пользователь", :user
    column "Телефон", :phone
    column :status do |company|
      I18n.t("activerecord.activation_statuses.#{company.status}")
    end
    column "Сайт" do |company|
      link_to company.site.main_url, company.site.main_url, :target => '_blank' if company.site
    end
    actions do |company|
      if company.status == :active
        link_to 'Заблокировать', lock_admin_company_path(company), :method => :put, :confirm => 'Заблокировать'
      else
        link_to 'Активировать', activate_admin_company_path(company), :method => :put, :confirm => 'Активировать'
      end
    end
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Логотип' do
        #Вывод логотипа
        image_tag(company.logotype, :height => '100')
      end
      row 'E-mail' do
        company.user.email
      end
      row 'Название' do
        company.name
      end
      row 'Сайт' do
        link_to company.site.main_url, company.site.main_url, :target => '_blank'
      end
      row 'Полное юридическое название' do
        company.legal_name
      end 
      row 'Телефон' do
        company.phone
      end
      row 'Описание' do
        company.description
      end
      row 'Дата регистрации' do
        company.created_at
      end
    end
  end
  
  form :partial => 'form'

  scope_to do
    Class.new do
      def self.companies
        Company.unscoped
      end
    end
  end
end
