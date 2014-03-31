# encoding: utf-8

class Delivety < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :code, :company_id, :cost, :graph, :period, :default, :conditions, :free
  
  belongs_to :company

  validates :company_id, :presence => true
  validates :cost, :numericality => true, :allow_nil => true
  validates :code, :presence => true, :uniqueness => { :scope => :company_id }

  before_save do
    if default?
      company.deliveties.where(:default => true).where('id != ?', id).update_all(:default => false)
    elsif !company.delivety
      self.default = true
    end
    self.cost = 0 if self.cost.nil?
  end

  after_destroy { company.deliveties.first.try(:update_attribute, :default, true) unless company.delivety }

  default_scope order('`default` desc')

  def parsed_period
    m = period.to_s.match(/^(?<from_hour>\d{2})?:(?<from_minute>\d{2})?-(?<to_hour>\d{2}):(?<to_minute>\d{2})$/) || {}
    OpenStruct.new(:from_hour => m[:from_hour], :from_minute => m[:from_minute], :to_hour => m[:to_hour], :to_minute => m[:to_minute], :from => "#{m[:from_hour]}:#{m[:from_minute]}", :to => "#{m[:to_hour]}:#{m[:to_minute]}")
  end

  def title
    "#{code} / #{cost} руб."
  end
end
