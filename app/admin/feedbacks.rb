# coding: utf-8

ActiveAdmin.register Feedback do
  
  menu :label => "Отзывы", :parent => "Управление контентом"
  
  filter :title, :label => 'Заголовок'
  filter :created_at, :label => 'Дата'

  contentment = [
    'Отрицательный',
    'Положительный'
  ]
  contentment_hash = {
    :Отрицательный => 0,
    :Положительный => 1
  }

  index do
    column "Заголовок", :title
    column "Комментарий", :comment
    default_actions
  end
  
  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row 'Заголовок' do
        feedback.title
      end
      row 'Комментарий' do
        feedback.comment
      end
      row 'Плюсы' do
        feedback.plus
      end
      row 'Минусы' do
        feedback.minus
      end
      row 'Статус' do
        contentment[feedback.contentment]
      end

    end
    active_admin_comments
  end
  
  form do |f|
    f.inputs "Детали товара" do
      f.input :title, :label => "Заголовок"
      f.input :comment, :label => "Комментарий"
      f.input :plus, :label => "Плюсы"
      f.input :minus, :label => "Минусы"
      f.input :contentment, :label => "Статус", :as => :radio, :collection => contentment_hash
      f.input :entity_type, :label => "Тип сущности"
      f.input :entity_id, :label => "ID сущности"
      f.input :user_id, :label => "Пользователь", :as => :select, :collection => User.all
    end
    f.buttons
  end
  
end
