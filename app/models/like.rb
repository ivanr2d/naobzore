class Like < ActiveRecord::Base
  attr_accessible :entity_id, :entity_type, :user_id
  
  belongs_to :entity, :polymorphic => true
  belongs_to :user
  
  after_create { entity.increment!(:likes_count) }
  after_destroy { entity.decrement!(:likes_count) }
end
