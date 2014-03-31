class Characteristic < ActiveRecord::Base
  attr_accessible :entity_id, :entity_type, :key, :value
  belongs_to :entity, :polymorphic => true
  
  def self.get_separator(length)
    r = ''
    n = 50
    p = n - length
    while(p > 0)
      r += '. '
      p -= 1
    end
    return r
  end
  
end
