# coding: utf-8
include CategoriesHelper
ActiveAdmin.register Category do
  menu false
  
  config.filters = false

  config.clear_action_items!
  action_item :only => :index do
    link_to "Создать категорию", new_admin_category_path(:q => { :cat_type_eq => (params[:q] || {})['cat_type_eq'] })
  end

  controller do
    before_filter lambda { params[:category]['parents_ids'] = params[:category]['parents_ids'].join(',') }, :only => [:create, :update]
  end
  
  collection_action :index, :method => :get do
    @top_categories = Category.top.page(params[:page])
    @top_categories = @top_categories.where(:cat_type => params[:q]['cat_type_eq']) if params[:q] && params[:q]['cat_type_eq']
    @categories = @top_categories.map { |c| [c, c.deep_children] }.flatten
    
    respond_to do |format|
      format.html { render :layout => 'active_admin' }
    end
  end
  
  show do |ad|
    attributes_table do
      row :title
      row :alias
      row :parents_ids do
        raw category.parents.map { |p| link_to(p.title, [:admin, p]) }.join(', ')
      end
      row :image do
        image_tag(category.image, :height => 150, :width => 150)
      end
      row :created_at
    end
  end
  
  cat_types = {
    :Товары => 1,
    :Услуги => 2,
    :Вакансии => 3,
    :Новости => 4,
    :Справка => 5
  }
  form :partial => 'form'
end