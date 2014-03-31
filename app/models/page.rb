class Page < ActiveRecord::Base
  attr_accessible :title, :content, :link

  validates :title, :link, :presence => true, :length => {:minimum => 1, :maximum => 255}, :uniqueness => true
end
