# encoding: utf-8

class Act < ActiveRecord::Base
  attr_accessible :company_id, :entity_id, :entity_type, :sum
  acts_as_readable :on => :created_at

  validates :entity_type, :presence => true
  validates :company_id, :sum, :presence => true, :numericality => true

  belongs_to :company
  has_one :facture
  belongs_to :entity, :polymorphic => true

  def pdf_name
    "act_#{id}"
  end

  def name
    "Акт №#{id}"
  end

  def sum_without_nds
    sum
  end

  def sum_with_nds
    sum * 118 / 100.0
  end

  def nds
    sum_with_nds - sum_without_nds
  end
end
