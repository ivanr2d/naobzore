# encoding: utf-8

class Facture < ActiveRecord::Base
  attr_accessible :act_id, :company_id, :sum, :entity_id, :entity_type
  acts_as_readable :on => :created_at

  validates :company_id, :sum, :presence => true, :numericality => true
  validates :entity_type, :presence => true

  belongs_to :company
  belongs_to :act
  after_create { company.calc_balance! }
  
  def entity
    entity_type.constantize.unscoped.find(entity_id)
  end

  def pdf_name
    "facture_#{id}"
  end

  def name
    "Счёт-фактура №#{id}"
  end

  def price_for_one_entity
    case entity_type
    when 'Banner'
      Banner.week_price
    when 'CompaniesPackage'
      entity.package.price
    when 'Invoice'
      entity.sum
    end
  end

  # Сейчас счёт фактура выписывается на одну единицу услуг (пакет, баннер)
  def sum_with_nds
    #price_for_one_entity * 118 / 100.0
    sum * 118 / 100.0
  end

  def sum_without_nds
    price_for_one_entity
  end

  def nds
    sum_with_nds - sum_without_nds
  end

  def fill?
    entity.is_a?(Invoice) && entity.fill?
  end

  def used_sum
    if fill?
      sum
    else
      -1*sum
    end
  end
end
