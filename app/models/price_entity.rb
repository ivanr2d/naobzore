class PriceEntity < ActiveRecord::Base
  attr_accessible :article, :available, :category_id, :company_id, :description, :folder_id, :image, :maker, :measure, :name, :price, :price_id, :state, :warranty_time, :remote_image_url

  mount_uploader :image, ImageUploader
  attr_accessor :image_file_name

  validates_presence_of :category_id, :company_id, :name, :price_list_id
  validates_numericality_of :category_id, :company_id, :price_list_id, :article
  validates_numericality_of :folder_id, :price, :warranty_time, :allow_nil => true
  validates_uniqueness_of :article, :scope => [:company_id, :price_list_id]

  has_many :characteristics, :as => :entity
  belongs_to :price_list
  belongs_to :category
  belongs_to :folder
  has_many :photos, :as => :entity

  scope :with_unpublished, scoped

  before_create { self.available = !['-', ''].include?(available.to_s.strip); true }

  def self.price_columns
    %w(article name category_id description characteristics price measure remote_image_url available state maker folder_id warranty_time)
  end

  def characteristics_str
    characteristics.map { |c| "#{c.key}:#{c.value}" }.join(',')
  end
end
