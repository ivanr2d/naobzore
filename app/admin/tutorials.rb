# coding: utf-8
# TODO add link (not only local_file)

ActiveAdmin.register Tutorial do
  menu false

  filter :title, :label => 'Заголовок'

  index do
    column :preview do |tutorial| 
      image_tag tutorial.preview_url(:thumb), :width => 100 if tutorial.preview_url(:thumb)
    end
    column :local_file do |tutorial|
      link_to tutorial.local_file, tutorial.local_file_url, :target => :_blank if tutorial.local_file_url
    end
    column :title
    column :text
    default_actions
  end

  #---------------------------------------------------------
  # Страницы show
  #---------------------------------------------------------
  show do |ad|
    attributes_table do
      row :preview do |tutorial|
        image_tag tutorial.preview_url(:big) if tutorial.preview_url(:big)
      end
      row :local_file do |tutorial|
        link_to tutorial.local_file, tutorial.local_file_url if tutorial.local_file_url
      end
      row :title
      row :text
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Детали слайда" do
      f.input :title
      f.input :text
      f.input :preview, :as => :file
      f.input :local_file, :as => :file
    end
    f.buttons
  end

end
