# encoding: utf-8

class User < ActiveRecord::Base
  acts_as_paranoid  
  acts_as_reader
  before_save :default_values

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,  
         :registerable,
         :recoverable,  
         :rememberable,  
         :trackable,  
         :validatable,  
         :token_authenticatable,  
         :confirmable
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :password_confirmation, :remember_me, :lic, :prefered_contact, :sex, :city_id, :post_index,
                  :email, :active, :f_name, :l_name, :m_name, :password, :account_type, :mark, :fio,
                  :mini_photo, :skype, :city, :address, :phone, :birthday, :web, :main_photo, :icq,
                  :subscribe_lk, :subscribe_email, :subscribe_sms

  # Validations
  #validates :active, :account_type, :presence => true
  validates :email, :presence => true,
                    :length => {:minimum => 5, :maximum => 64},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :f_name, :l_name, :m_name, :skype, :length => {:minimum => 0, :maximum => 64}
  validates :phone, :address, :length => {:minimum => 0, :maximum => 255}
  validates :password_confirmation, :lic, :presence => true, :on => :create
  validates :post_index, :icq, :numericality => true, :allow_nil => true
  validates :skype, :length => {:minimum => 0, :maximum => 100}

  has_one :account , :class_name => "Company", :dependent => :destroy
  has_one :company , :class_name => "Company", :dependent => :destroy
  has_many :favorites
  has_many :likes
  has_many :subscribes
  has_many :categories, :through => :subscribes
  has_many :comments
  has_many :resumes
  has_and_belongs_to_many :companies
  has_many :sended_messages, :class_name => 'Message', :foreign_key => :from_id
  has_and_belongs_to_many :received_messages, :class_name => 'Message'
  
  mount_uploader :main_photo, ImageUploader
  attr_accessor :main_photo_file_name
  
  mount_uploader :mini_photo, ImageUploader
  attr_accessor :mini_photo_file_name
  
  after_find do |user|
    if user.main_photo == nil
      user.main_photo = 'default.png'
    end
  end

  has_many :output_messages, :foreign_key => 'from_id', :class_name => 'Message'
  alias :input_messages :received_messages

  def lic
    @lic
  end
  def lic=(new_value)
    @lic = new_value
  end
  
  def default_values
    if !self.active
      self.active = 0
    end
    if !self.account_type
      self.account_type = 0
    end
  end
  
  #Получение имени из емайла
  def self.get_name name
    temp = name.split("@")
    return temp[0]
  end
  
  def self.get_fio user
    result = ''
    if user.f_name != ''
      result += user.f_name
    end
    if user.l_name != ''
      result += ' ' + user.l_name
    end
    if result == ''
      result = user.email.split("@")[0]
    end
    return result
  end

  def fi
    [f_name, l_name].join ' '
  end

  def fio
    [f_name, m_name, l_name].compact.join ' '
  end

  def balance
    0
  end

  def status
    'активирован'
  end

  def phones
    phone.to_s.split(';').map do |phone|
      m = phone.match(/\+7\((?<phone_code>\d+)\)(?<phone_number>\d+)(\((?<phone_dob>\d+)\))?/)
      { :phone_code => m[:phone_code], :phone_number => m[:phone_number], :phone_dob => m[:phone_dob] }
    end
  end

  def prefered_contacts
    prefered_contact.to_s.split(';')
  end

  def admin?
    account_type == 'admin'
  end

  # TODO добавить возможность изменения дня рождения в админке
  def as_json options = {}
    res = {
      :id => id,
      :email => email,
      :phone => phone,
      :fio => fio,
      :f_name => f_name,
      :m_name => m_name,
      :l_name => l_name,
      :birthday => birthday.try(:strftime, '%d.%m.%Y'),
      :companies => companies.map(&:legal_name),
      :main_photo => main_photo.url,
      :fio => fio
    }
  end

  [:good, :service, :job, :campaign, :new, :feedback].each do |field|
    define_method "ignored_#{field}s".to_sym do
      if self["ignored_#{field}s".to_sym].present?
        self["ignored_#{field}s".to_sym]
      else
        '0'
      end
    end
  end

  def self.support
    find_by_email('support@naobzore.ru')
  end

  def self.complaint
    find_by_email('complaint@naobzore.ru')
  end
end
