class Campaign < ActiveRecord::Base
  include Entity
  include ModelSociality

  default_scope lambda { where('start_at <= :now and end_at >= :now', :now => Time.now) }

  belongs_to :folder
  belongs_to :entity, :polymorphic => true, :conditions => {:published => [false, true]}

  before_save :set_spread_fields!, :if => Proc.new { entity_id_changed? || entity_type_changed? }
  after_save :set_entity_campaign_id!, :if => Proc.new { entity_id_changed? || entity_type_changed? }

  def set_published_by_packages
    self.published = company.campaigns_allowed > 0
    true
  end

  private

  def set_spread_fields!
    self.entity_id = self.entity_type = nil unless spread == :entity
    self.folder_id = nil unless spread == :folder
  end

  def set_entity_campaign_id!
  	entity_type_was.constantize.find(entity_id_was).update_attribute(:campaign_id, nil) if entity_id_was && entity_type_was
  	entity_type.constantize.find(entity_id).update_attribute(:campaign_id, id) if entity_id && entity_type
  end
end
