# encoding: utf-8

ActiveAdmin.register Message do
  menu false

  config.clear_action_items!
  action_item do
    link_to 'Создать сообщение', new_admin_message_path(:mtype => (params[:q] || {})['mtype_eq'])
  end

  filter :from, :collection => User.joins(:company).map { |u| [u.email, u.id] }
  filter :subject
  filter :created_at

  index do
    column :id
    column :from
    column :receivers do |message|
      message.receivers.map { |user| user.email }.join(', ')
    end
    column :subject
    column :text do |message|
      truncate(message.text, :length => 20)
    end
    column :created_at
    actions :defaults => false do |message|
      link_to('Удалить', [:admin, message], :method => :delete, :confirm => 'Удалить сообщение?')
    end
  end

  show do |m|
    attributes_table do
      row :from
      row :receivers do |message|
        message.receivers.map { |user| user.email }.join(', ')
      end
      row :subject
      row :text
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :from_id, :as => :hidden, :value => current_user.id
      f.input :mtype, :as => :hidden, :value => params[:mtype]
      f.input :receivers, :collection => User.joins(:company).map { |u| [u.email, u.id] }
      f.input :subject
      f.input :text
    end
    f.actions
  end
end
