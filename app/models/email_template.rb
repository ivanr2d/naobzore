class EmailTemplate < ActiveRecord::Base
  attr_accessible :body, :description, :name

  validates :body, :presence => true
  validates :name, :presence => true, :uniqueness => true
end
