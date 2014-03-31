# encoding: utf-8

ActiveAdmin.register Package do
  menu false

  config.filters = false

  member_action :delete, :method => :get do
    @package = Package.find(params[:id])
  end

  index do
    column :id
    column :name
    column :price
    column :goods_and_services
    column :jobs
    column :campaigns
    column :sms
    column :calls
    column :delete_after
    column :company
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :ptype, :as => :select, :collection => Package.columns_hash['ptype'].limit.map { |t| [I18n.t("activerecord.package_types.#{t}"), t] }
      f.input :price
      f.input :goods_and_services
      f.input :jobs
      f.input :campaigns
      f.input :sms
      f.input :calls
      f.input :delete_after
      f.input :company
    end
    f.actions
  end

  show do |package|
    attributes_table do
      row :id
      row :name
      row :price
      row :goods_and_services
      row :jobs
      row :campaigns
      row :sms
      row :calls
      row :delete_after
      row :company
    end
  end
end
