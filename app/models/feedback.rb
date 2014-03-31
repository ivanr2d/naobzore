# encoding: utf-8

class Feedback < ActiveRecord::Base
  
  @limit = 3
  
  attr_accessible :annonce, :comment, :contentment, :entity_id, :entity_type, :minus, :plus, :name, :user_id, :category_id

  belongs_to :entity, :polymorphic => true
  has_many :likes, :as => :entity, :dependent => :destroy
  belongs_to :user
  
  validates :comment, :contentment, :minus, :plus, :presence => true

  def human_contentment
    contentment > 0 ? 'Позитивный' : 'Негативный'
  end

  # XXX 
  def title
    name
  end
  
  [:plus, :minus].each do |field|
    define_method "#{field}es".to_sym do
      send(field).to_s.split(',').map(&:strip).delete_if { |p| p.empty? }
    end
  end

  def self.get_limit
    @limit
  end
  
  def self.get_p_count(entity_type, entity_id)
    Feedback.where(:entity_type => entity_type, :entity_id => entity_id, :contentment => 1).count
  end
  def self.get_n_count(entity_type, entity_id)
    Feedback.where(:entity_type => entity_type, :entity_id => entity_id, :contentment => 0).count
  end
  
  def self.get_picture(feedback)
    result = nil
    
    if feedback.entity_type == 'Company'
      result = feedback.entity.logotype.url
    elsif feedback.entity_type == 'Campaign'
      result = feedback.entity.company.logotype.url
    else
      result = feedback.entity.image.url
    end
    
    return result
  end
  
end
