class Graphic < ActiveRecord::Base
  attr_accessible :name

  default_scope order(:name)

  has_many :jobs, :dependent => :nullify
end
