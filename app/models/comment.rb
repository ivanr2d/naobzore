class Comment < ActiveRecord::Base
  LAST_COUNT = 6
  attr_accessible :entity_id, :entity_type, :text, :user_id

  belongs_to :user
  belongs_to :entity, :polymorphic => true

  after_create { entity.increment!(:comments_count) if entity.respond_to? :comments_count }
  after_destroy { entity.decrement!(:comments_count) if entity.respond_to? :comments_count }

  validates :entity_id, :entity_type, :text, :user_id, :presence => true
end
