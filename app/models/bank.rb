class Bank < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :address, :company_id, :condition, :logotype, :name, :phone
  
  belongs_to :company
  
  #Для загрузки логотипа
  mount_uploader :logotype, BankLogotypeUploader
  attr_accessor :logotype_file_name

  validates_presence_of :name, :company_id

  def phone_code
    if matches = phone.to_s.match(/\((\d+)\)/)
      matches[1]
    else
      nil
    end
  end

  def phone_number
    if matches = phone.to_s.match(/\)(\d+)/)
      matches[1]
    else
      nil
    end
  end
end
