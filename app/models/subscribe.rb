class Subscribe < ActiveRecord::Base
  attr_accessible :category_id, :user_id
  
  belongs_to :category
  belongs_to :user

  validates :category_id, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true, :uniqueness => {:scope => :category_id}
end
