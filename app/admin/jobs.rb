# coding: utf-8

ActiveAdmin.register Job do
  before_filter do
    Job.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  member_action :unpublish, :method => :put do
    job = Job.find(params[:id])
    job.update_attribute(:published, false)
    Message.create(:text => "Акция \"#{job.name}\" снята с публикации", :from_id => Company.main.id, :to_id => job.company_id)
    redirect_to admin_jobs_path, :notice => 'Заблокировано'
  end
  
  menu :label => "Вакансии", :parent => "Управление контентом"
  
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
    actions do |job|
      link_to 'Заблокировать', unpublish_admin_job_path(job), :method => :put, :confirm => 'Заблокировать?'
    end
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Изображение' do
        image_tag(job.image, :width => 150, :height => 150)
      end
      row 'Компания' do
        job.company
      end
      row 'Категория' do
        job.category
      end 
      row 'Название' do
        job.name
      end
      row 'Описание' do
        job.description
      end
      row 'Требования' do
        job.requirements
      end
      row 'Зарплата от' do
        job.salary_from
      end
      row 'Зарплата до' do
        job.salary_to
      end
      row 'Дата добавления' do
        job.created_at
      end
    end
    active_admin_comments
  end
  
  probation = {
    :Да => 1,
    :Нет => 0
  }
  
  form do |f|
    f.inputs "Детали товара" do
      f.input :image, :label => 'Изображение', :as => 'file'
      f.input :category, :label => "Категория"
      f.input :company, :label => "Компания"
      f.input :name, :label => "Название"
      f.input :description, :label => "Описание"
      f.input :requirements, :label => "Требования"
      f.input :graphic, :label => "График работы", :as => :select, :collection => Job.graphics
      f.input :sex, :label => "Пол", :as => :select, :collection => Job.sexs
      #Изменяется размер поля
      f.input :salary_from, :label => "Зарплата от", :input_html => { :size => 10, :style => 'max-width: 100px;' }
      f.input :salary_to, :label => "Зарплата до", :input_html => { :size => 10, :style => 'max-width: 100px;' }
      f.input :probation, :label => "Стажировка", :as => :radio, :collection => probation
    end
    f.buttons
  end
  
end
