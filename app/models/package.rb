# encoding: utf-8

class Package < ActiveRecord::Base
  attr_protected

  validates_presence_of :name, :price
  validates_numericality_of :price

  has_many :companies_packages
  has_many :companies, :through => :companies_packages
  # private package
  belongs_to :company

  scope :placing, where(:ptype => :placing)
  scope :communication, where(:ptype => [:sms, :minutes])

  search_methods :ptype_eq
  scope :ptype_eq, lambda { |ptype| where(:ptype => ptype) }
  search_methods :ptype_in
  scope :ptype_in, lambda { |ptypes| ptypes = ptypes.split(',') if ptypes.is_a?(String); where(:ptype => ptypes) }

  scope :for_company, lambda { |company| where(:company_id => [nil, company.id]) }

  def full_name
    if ptype == :placing 
      "Пакет размещения \"#{name}\""
    elsif ptype == :sms
      "Пакет SMS \"#{name}\""
    else
      "Пакет голосовых минут \"#{name}\""
    end
  end
end
