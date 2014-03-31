class Visit < ActiveRecord::Base
  attr_accessible :entity_id, :entity_type, :ip
  
  belongs_to :entity, :polymorphic => true
  
  def self.plus(entity_id, entity_type, ip)
    result = false
    
    visit = Visit.where('(DATE(created_at) = DATE(?)) AND (ip = ?) AND (entity_type = ?) AND (entity_id = ?)', Time.now, ip, entity_type, entity_id)
    
    if visit.count < 1
      Visit.new(:entity_id => entity_id, :ip => ip, :entity_type => entity_type).save!
      result = true
    end
    
    return result
  end
end
