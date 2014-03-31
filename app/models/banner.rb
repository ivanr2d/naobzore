# coding: utf-8

class Banner < ActiveRecord::Base
  attr_accessible :banner, :company_id, :link, :week, :title, :banner_type

  belongs_to :company
  has_one :facture, :as => :entity
  has_one :act, :as => :entity
  has_one :invoice, :as => :entity

  validates :week, :banner, :link, :presence => true
  
  #Для загрузки картинок
  mount_uploader :banner, BannerUploader
  attr_accessor :banner_file_name
  
  validates :company_id, :presence => true, :numericality => true
  validate :validate_minimum_image_size

  search_methods :banner_type_eq
  scope :banner_type_eq, lambda { |banner_type| where(:banner_type => banner_type) }

  def usage_koef
    Date.today.cweek < week ? 1 : 0
  end

  after_destroy do
    # Создаём акт выполненных работ
    act = Act.create(:company_id => company_id, :sum => self.class.week_price * usage_koef, :entity_id => self.id, :entity_type => self.class.to_s)
    # создаём счёт фактуру
    Facture.create(:company_id => company_id, :sum => self.class.week_price * usage_koef, :act_id => act.id, :entity_id => self.id, :entity_type => self.class.to_s)
  end

  def validate_minimum_image_size
    
    file_size = self.banner.file_size #w - file_size[0]; h - file_size[1]
    
    if (! file_size.nil?)
      if (file_size[:width] < 557 || file_size[:height] < 188) || (file_size[:width] > 595 || file_size[:height] > 266)
        errors.add :base, "Размер банера не может быть меньше 557x188 и больше 595x266" 
      end
    end
  end

  def self.week_price
    Settings.find_by_key(:banner_week_price).value.to_i || 1199
  end

  def self.period_in_months
    6
  end

  def self.week_limit
    5
  end

  def self.week_busy? week, type
    Banner.where(:week => week, :banner_type => type).where('created_at > ?', Time.now - (period_in_months + 1).months).count >= week_limit
  end
  
end
