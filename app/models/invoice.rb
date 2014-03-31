# encoding: utf-8

class Invoice < ActiveRecord::Base
  attr_protected
  acts_as_readable :on => :created_at

  validates :company_id, :sum, :presence => true, :numericality => true
  validates :entity_type, :presence => true
  validate :have_money

  belongs_to :company
  has_one :facture, :as => :entity
  has_one :act, :as => :entity

  before_create { self.status = :complete if out? }
  # Если подтеврждено пополнение счёта - создаётся счёт фактура на аванс
  after_save :create_avance_facture, :if => Proc.new { fill? && status_changed? && status == :complete }
  #after_create { company.calc_balance! }

  scope :complete, where(:status => :complete)
  scope :fill, where(:entity_type => 'Fill')
  scope :out, where('entity_type != "Fill"')

  search_methods :status_eq
  scope :status_eq, lambda { |status| where(:status => status) }

  def have_money
    errors.add(:base, :not_enough_money) if out? && company.balance < sum
  end

  def create_avance_facture 
    Facture.create(:company_id => company_id, :sum => sum_not_nds, :entity_id => self.id, :entity_type => self.class.to_s)
  end

  #before_save do
 #   self.sum = sum_not_nds
 # end

  def pdf_name
    "invoice_#{id}"
  end

  def entity
    entity_type.constantize.unscoped.find(entity_id) rescue nil
  end

  def name
    "Счёт №#{id}"
  end

  def full_name
    "#{name}. #{entity ? entity.full_name : I18n.t("invoices.entities.#{entity_type}")}"
  end

  def pay_to
    # TODO not sure
    created_at + 15.days
  end

  def nds
    n = (sum * 18) / 118.0
    n.round(2)
  end

  def sum_with_nds
    sum + nds
  end

  def sum_not_nds
    sum - nds
  end

  def sum_without_nds
    sum
  end

  def fill?
    entity_type == 'Fill'
  end

  def out?
    !fill?
  end

  # Фактура к той же сущности что и счёт
  def same_facture
    Facture.where(:company_id => company_id, :entity_id => entity_id, :entity_type => entity_type).where('entity_id IS NOT NULL').first
  end

  # Сумма пополнения(>0) или потраченная(<0)
  def used_sum
    if fill?
      sum_with_nds
    else
      -1*sum_with_nds
    end
  end
end
