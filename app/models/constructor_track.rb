class ConstructorTrack < ActiveRecord::Base
  attr_accessible :category, :video

  validates :category, :presence => true, :uniqueness => true
  validates :video, :presence => true

  mount_uploader :video, VideoUploader
  attr_accessor :video_file_name
end
