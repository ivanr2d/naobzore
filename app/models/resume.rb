# encoding: utf-8

class Resume < ActiveRecord::Base
  # XXX многие поля дублируют поля пользователя
  attr_accessible :birthday, :children, :driving_permit, :email, 
                  :f_name, :family_status, :home_phone, :icq, :l_name, :m_name, 
                  :mob_phone, :photo, :sex, :skype, :type_connection, :salary_from, :name, :category_id
                  
  belongs_to :user
  belongs_to :category
  has_many :companies_resumes
  has_many :jobs, :through => :companies_resumes
  has_many :companies_resumes
  has_many :companies, :through => :companies_resumes
  
  mount_uploader :photo, ImageUploader
  attr_accessor :photo_file_name

  validates :f_name, :m_name, :l_name, :sex, :birthday, :name, :presence => true
  
end
