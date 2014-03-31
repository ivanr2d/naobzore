# encoding: utf-8

ActiveAdmin.register Invoice do
  menu :label => 'Счета', :parent => 'Документооборот', :priority => 2

  filter :company
  filter :created_at

  member_action :complete, :method => :put do
    Invoice.find(params[:id]).update_attribute(:status, :complete)
    redirect_to admin_invoices_path(:q => { :entity_type_eq => 'Fill' }), :notice => 'Оплачен'
  end

  member_action :cancel, :method => :put do
    Invoice.find(params[:id]).update_attribute(:status, :cancel)
    redirect_to admin_invoices_path(:q => { :entity_type_eq => 'Fill' }), :notice => 'Отказано'
  end

  index do
    column :id
    column :sum_with_nds
    column :company
    column :created_at
    column :status
    actions do |invoice|
      if params[:q] && params[:q]['entity_type_eq'] == 'Fill'
        raw [link_to('Оплатить', complete_admin_invoice_path(invoice), :method => :put, :confirm => 'Оплатить?'),
        link_to('Отказать', cancel_admin_invoice_path(invoice), :method => :put, :confirm => 'Отказать?')].join('&nbsp;&nbsp;')
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :sum
      f.input :company
      f.input :entity_type, :as => :select, :collection => %w(Fill Banner CompaniesPackage).map { |t| [I18n.t("invoices.entities.#{t}"), t] }
      f.input :from_aps, :as => :hidden, :value => true
    end
    f.actions
  end
end
