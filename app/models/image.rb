class Image < ActiveRecord::Base
  attr_accessible :entity_id, :category_id, :url, :entity_type, :entity
  
  #Для загрузки файлов
  mount_uploader :url, ImageUploader
  attr_accessor :url_file_name
 
  belongs_to :entity, :polymorphic => true
  
  
  
end
