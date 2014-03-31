# coding: utf-8

class Job < ActiveRecord::Base
  include Entity
  include ModelSociality

  belongs_to :graphic
  has_many :companies_resumes
  has_many :resumes, :through => :companies_resumes

  def possible_resumes
    Resume.where("name LIKE ?", "%#{name}%")
  end

  def set_published_by_packages
    self.published = company.jobs_allowed > 0
    true
  end
  
  def self.graphics
    result = [ ['Сменный', 0], ['Свободный', 1], ['Частичная занятность', 2], ['Удаленная работа', 3] ]
    return result
  end
  
  def self.sexs
    result = [ ['Мужской', 0], ['Женский', 1] ]
    return result
  end
  
  #Стажировка
  def self.probation
    [['Нет', 0], ['Да', 1]]
  end
  
  def self.get_graphic(graphic)
    result = nil
    Job.graphics.each do |value, key|
      if graphic == key
        result = value
      end
    end
    return result
  end
  
  def self.get_sex(sex)
    result = nil
    Job.sexs.each do |value, key|
      if sex == key
        result = value
      end
    end
    return result
  end
  
  #Стажировка
  def self.get_probation(probation)
    result = nil
    Job.probation.each do |value, key|
      if probation == key
        result = value
      end
    end
    return result
  end

  def contact_phones
    contact_phone.to_s.split(';').map do |phone|
      if m = phone.match(/\+7\((?<phone_code>\d+)\)(?<phone_number>\d+)(\((?<phone_dob>\d+)\))?/)
        { :phone_code => m[:phone_code], :phone_number => m[:phone_number], :phone_dob => m[:phone_dob] }
      end
    end.compact
  end

  def contact_faxes
    contact_fax.to_s.split(';').map do |fax|
      if m = fax.match(/\+7\((?<fax_code>\d+)\)(?<fax_number>\d+)(\((?<fax_dob>\d+)\))?/)
        { :fax_code => m[:fax_code], :fax_number => m[:fax_number] }
      end
    end.compact
  end
end
