# encoding: utf-8

class Warranty < ActiveRecord::Base
  attr_accessible :code, :company_id, :conditions, :default, :months

  validates_presence_of :code, :company_id, :conditions, :months
  validates_uniqueness_of :code, :scope => :company_id

  belongs_to :company

  before_save do
    if default?
      company.warranties.where(:default => true).where('id != ?', id).update_all(:default => false)
    elsif !company.warranty
      self.default = true
    end
  end

  after_destroy { company.warranties.first.try(:update_attribute, :default, true) unless company.warranty }

  default_scope order('`default` desc')

  def title
    "#{code} / #{months} мес."
  end
end
