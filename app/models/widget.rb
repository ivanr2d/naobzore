class Widget < ActiveRecord::Base
  attr_accessible :pos, :dual, :title, :text, :translit

  before_validation { self.pos = Widget.count unless pos }

  validates :title, :presence => true

  default_scope order(:pos)
end
