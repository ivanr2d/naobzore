class Settings < ActiveRecord::Base
  attr_accessible :file, :key, :value, :title
  
  mount_uploader :file, FileUploader
  attr_accessor :file_file_name

  validates :key, :presence => true, :uniqueness => true
end
