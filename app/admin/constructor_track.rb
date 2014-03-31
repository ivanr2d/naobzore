ActiveAdmin.register ConstructorTrack do
  menu false
  config.filters = false

  index do
    column :category
    column :video do |track|
      link_to File.basename(track.video_url), track.video_url, :target => :_blank
    end
    actions
  end

  show do |track|
    attributes_table do 
      row :category
      row :video do
        link_to File.basename(track.video_url), track.video_url, :target => :_blank
      end
      row :created_at
    end
  end
end
