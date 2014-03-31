class Photo < ActiveRecord::Base
  attr_accessible :company_id, :file, :entity_id, :entity_type, :main, :size

  mount_uploader :file, PhotoUploader

  belongs_to :entity, :polymorphic => true, :conditions => {:published => [false, true]}
  belongs_to :company

  before_save { self.size = file.size if file.present?; true }
  # set main
  before_create :set_main
  before_save :set_main, :if => Proc.new { entity_id_changed? || entity_type_changed? }

  def url(version = nil)
    file.url(version)
  end

  def path
    file.path
  end

  def to_s
    url
  end

  private
  
  def set_main
    if entity_id
      main_photos = Photo.where(:entity_id => entity_id, :entity_type => entity_type, :main => true)
      if main?
        main_photos.update_all(:main => false)
      elsif main_photos.empty?
        self.main = true
      end
    else
      self.main = false
    end
    if entity_id_was && Photo.where(:entity_id => entity_id_was, :entity_type => entity_type_was, :main => true).where('id != ?', id).empty?
      Photo.where(:entity_id => entity_id_was, :entity_type => entity_type_was).first.try(:update_attribute, :main, true)
    end
  end
end
