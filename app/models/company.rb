# coding: utf-8

class Company < ActiveRecord::Base
  acts_as_paranoid
  attr_protected

  validates :user_id, :category_id, :presence => true
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 128}
  validates :short_description, :length => {:minimum => 0, :maximum => 500}
  validates :ogrn, :fax, :length => {:minimum => 0, :maximum => 32}
  validates :user_id, :post_index, :icq, :creation_year, :numericality => true, :allow_nil => true
  validates_associated :category
  validates :settlement_account, :length => {:is => 20}, :numericality => true, :allow_blank => true
  validates :bik, :length => {:is => 9}, :numericality => true, :allow_blank => true
  validates :bank_cor_account, :length => {:is => 20}, :allow_blank => true
  #validates :inn, :length => {:is => 12}, :if => Proc.new { self.org_form == 'ИП' }, :allow_blank => true
  #validates :inn, :length => {:is => 10}, :if => Proc.new { self.org_form != 'ИП' }, :allow_blank => true
  validates :inn, :length => { :minimum => 10, :maximum => 12 }, :allow_blank => true
  validates :kpp, :length => {:is => 9}, :numericality => true, :allow_blank => true


  
  #Для загрузки логотипа
  mount_uploader :logotype, LogotypeUploader
  attr_accessor :logotype_file_name
  mount_uploader :tmp_logotype, LogotypeUploader
  attr_accessor :tmp_logotype_file_name
  mount_uploader :director_signature, SignatureUploader
  attr_accessor :director_signature_file_name
  mount_uploader :print, PrintUploader
  attr_accessor :print_file_name

  belongs_to :user
  belongs_to :category
  has_many :deliveties, :dependent => :destroy
  has_many :warranties, :dependent => :destroy
  has_many :banks, :dependent => :destroy
  has_many :goods, :dependent => :destroy
  has_many :services, :dependent => :destroy
  has_many :campaigns, :dependent => :destroy
  has_many :jobs, :dependent => :destroy
  has_many :images, :as => :entity
  has_many :favorites, :as => :entity
  has_many :feedbacks, :as => :entity
  has_many :likes, :as => :entity
  has_many :visits
  has_many :companies_packages
  has_many :packages, :through => :companies_packages
  # private package
  has_one :package
  has_many :folders
  has_many :price_lists
  has_and_belongs_to_many :users
  has_many :companies_menus
  has_one :site, :dependent => :destroy
  accepts_nested_attributes_for :site
  has_many :subdomains
  has_many :invoices
  has_many :factures
  has_many :acts
  has_many :banners
  has_many :photos
  has_many :news
  has_many :companies_resumes
  has_many :resumes, :through => :companies_resumes

  scope :created_after, lambda { |time| where('created_at > ?', time) }

  default_scope where(:main => false)

  before_save { self.legal_name = self.name if self.legal_name.blank? }

  def menus
    Menu.joins("LEFT JOIN companies_menus ON menus.id = companies_menus.menu_id AND companies_menus.company_id = #{self.id} ORDER BY companies_menus.pos, menus.id")
  end
  
  def delivety
    deliveties.first
  end

  def warranty
    warranties.first
  end

  def bank
    banks.first
  end

  def self.types
    result = [ ['Юридическое лицо', 1], ['Индивидуальный предприниматель', 2] ]
    return result
  end
  
  def self.get_type(type)
    result = nil
    Company.types.each do |value, key|
      if type == key
        result = value
      end
    end
    return result
  end

  def goods_and_services_limit
    packages.map(&:goods_and_services).sum
  end

  def goods_and_services_allowed
    goods_and_services_limit - goods.count - services.count
  end

  def jobs_limit
    packages.map(&:jobs).sum
  end

  def jobs_allowed
    jobs_limit - jobs.count
  end

  def campaigns_limit
    packages.map(&:campaigns).sum
  end

  def campaigns_allowed
    campaigns_limit - campaigns.count
  end

  def sms_limit
    packages.map(&:sms).sum # TODO - sms count
  end

  def sms_allowed
    0
  end

  def package_duration package
    if cp = companies_packages.where(:package_id => package.id).order('end_at desc').first
      cp.end_at.year * 12 + cp.end_at.month - cp.start_at.year * 12 - cp.start_at.month
    else
      0
    end
  end

  def phones
    phone.to_s.split(';').map do |phone|
      if m = phone.match(/\+7\((?<phone_code>\d+)\)(?<phone_number>\d+)(\((?<phone_dob>\d+)\))?/)
        { :phone_code => m[:phone_code], :phone_number => m[:phone_number], :phone_dob => m[:phone_dob] }
      end
    end.compact
  end

  def faxes
    fax.to_s.split(';').map do |fax|
      if m = fax.match(/\+7\((?<fax_code>\d+)\)(?<fax_number>\d+)(\((?<fax_dob>\d+)\))?/)
        { :fax_code => m[:fax_code], :fax_number => m[:fax_number] }
      end
    end.compact
  end

  def schedule
     JSON.parse(self[:schedule]).map(&:symbolize_keys) rescue [
      {:f => '10:00', :t => '19:00', :bf => '13:00', :bt => '14:00'},
      {:f => '10:00', :t => '19:00', :bf => '13:00', :bt => '14:00'},
      {:f => '10:00', :t => '19:00', :bf => '13:00', :bt => '14:00'},
      {:f => '10:00', :t => '19:00', :bf => '13:00', :bt => '14:00'},
      {:f => '10:00', :t => '19:00', :bf => '13:00', :bt => '14:00'},
      {:w => true},
      {:w => true}
    ]
  end

  def full_address
    res = []
    res << "#{post_index}" unless post_index.blank?
    res << "г. #{city}" unless city.blank?
    unless street.blank?
      res << "ул. #{street} #{house}"
      res << "стр. #{building}" unless building.blank?
      res << "офис #{office}" unless office.blank?
    end
    res.join(', ')
  end

  alias :address :full_address

  def main_phone
    phone.to_s.split(';').first
  end

  def self.main
    where(:main => true).first
  end

  # TODO maybe find better solution
  def save(*)
    Company.send(:with_exclusive_scope) { super }
  end

  def director_fio
    "#{director_lname}#{director_lname.blank? ? '' : ' '}#{director_fname.to_s[0]}#{director_fname.blank? ? '' : '.'}#{director_mname.to_s[0]}#{director_mname.blank? ? '' : '.'}"
  end

  def calc_balance!
    self.balance = factures.map(&:used_sum).sum and save
  end

  def human_balance
    "Баланс: #{balance} руб."
  end

  # Каталог товаров и услуг. Структура {category => {:count => , :children => }}
  # TODO cache
  def catalog entities = goods + services
    res = {}
    entities.each do |entity|
      entity.category.hierarhies.each do |hierarhy|
        slice = nil
        hierarhy.each do |category|
          slice = merge_category category, slice || res
        end
      end
    end
    res
  end

  def coords
    self[:coords].blank? ? '51.8049,55.147347' : self[:coords]
  end

  def send_balance_notification
    message = Message.create(:from_id => Company.main.user.id, :mtype => :notification, :text => 'Ваш баланс близок к нулю')
    user.received_messages << message
  end

  private 

  def merge_category category, hash
    if hash[category]
      hash[category][:count] += 1
    else
      hash[category] = { :count => 1, :children => {} }
    end
    hash[category][:children]
  end
end
