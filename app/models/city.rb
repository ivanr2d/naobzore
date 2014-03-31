class City < ActiveRecord::Base
  attr_accessible :name, :priority

  default_scope order('priority desc, name asc')
end
