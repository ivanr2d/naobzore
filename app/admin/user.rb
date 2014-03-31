# coding: utf-8

ActiveAdmin.register User do
  
  menu :label => "Пользователи", :priority => 1, :parent => 'Пользователи'
  
  #---------------------------------------------------------
  # Фильтр
  #--------------------------------------------------------- 
  filter :email
  filter :f_name, :label => 'Фамилии'
  filter :l_name, :label => 'Имени'
  filter :m_name, :label => 'Отчеству'
  filter :created_at, :label => 'Дата'
  
  #---------------------------------------------------------
  # Страница вывода списка
  #--------------------------------------------------------- 
  index do
    column "E - mail", :email
    column "Фамилия", :f_name
    column "Имя",  :l_name
    column "Отчество",  :m_name
    default_actions
  end
  
  #---------------------------------------------------------
  # Форма
  #---------------------------------------------------------  
  types = {
    :Пользователь => 0,
    :Компания => 1
  }
  
  status = {
    :Неактивен => 0,
    :Активен => 1
  }
  
  form do |f|
    f.inputs "Детали пользователя" do
      f.input :main_photo, :label => 'Главное изображение', :as => 'file'
      f.input :mini_photo, :label => 'Маленькое изображение', :as => 'file'
      f.input :email, :label => "E - mail"
      f.input :password, :label => "Пароль"
      f.input :password_confirmation, :label => "Повтор пароля"
      f.input :active, :label => "Статус", :as => :radio, :collection => status
      
      f.input :account_type, :label => "Тип", :as => :radio, :collection => types
      f.input :superadmin, :label => "Administrator"
    end
    f.buttons
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Фото' do
        image_tag(user.mini_photo, :width => 120, :height => 120)
      end
      row :email
      row 'Фамилия' do
        user.f_name
      end 
      row 'Имя' do
        user.l_name
      end 
      row 'Отчество' do
        user.m_name
      end
      row 'Тип' do
        (user.sign_in_count) ? "Компания" : "Пользователь"
      end
      row 'Колличество входов' do
        user.sign_in_count
      end
      row 'Последний вход' do
        user.last_sign_in_at
      end
      row 'Последний IP' do
        user.last_sign_in_ip
      end
      row 'Дата регистрации' do
        user.created_at
      end
    end
    active_admin_comments
  end
  
  create_or_edit = Proc.new {
    @user            = User.find_or_create_by_id(params[:id])
    @user.superadmin = params[:user][:superadmin]
    @user.attributes = params[:user].delete_if do |k, v|
      (k == "superadmin") ||
          (["password", "password_confirmation"].include?(k) && v.empty? && !@user.new_record?)
    end
    if @user.save
      redirect_to :action => :show, :id => @user.id
    else
      render active_admin_template((@user.new_record? ? 'new' : 'edit') + '.html.erb')
    end
  }
  
  member_action :create, :method => :post, &create_or_edit
  member_action :update, :method => :put, &create_or_edit

end
