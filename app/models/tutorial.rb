class Tutorial < ActiveRecord::Base
  attr_accessible :file_type, :link, :text, :title, :preview, :local_file

  validates :file_type, :title, :presence => true

  #Для загрузки видео
  mount_uploader :local_file, VideoUploader
  attr_accessor :local_file_file_name
  
  mount_uploader :preview, ImageUploader
  attr_accessor :preview_file_name
end
