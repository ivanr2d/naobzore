class Help < ActiveRecord::Base
  attr_accessible :category_id, :text, :title, :alias
  
  validates :category_id,  :presence => true
  validates :title, :alias, :presence => true, :length => {:minimum => 1, :maximum => 255}
  
  belongs_to :category
end
