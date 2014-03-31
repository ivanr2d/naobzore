class Favorite < ActiveRecord::Base
  attr_accessible :entity_id, :entity_type, :user_id
  
  belongs_to :entity, :polymorphic => true
  belongs_to :user
  
  #Получение sql для выборки с учетом типа
  def self.sql_types(types)
    result = ''
    
    types.each do |type|
      result += 'entity_type = \'' + type + '\' OR '
    end
    
    result = result[0, result.length - 4]
    
    return result
  end
  
end
