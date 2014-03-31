# encoding: utf-8

class CompaniesPackage < ActiveRecord::Base
  attr_accessible :auto, :company_id, :end_at, :package_id, :start_at

  belongs_to :company
  belongs_to :package
  has_one :facture, :as => :entity
  has_one :act, :as => :entity
  has_one :invoice, :as => :entity

  default_scope lambda { where('end_at > ?', Time.now) }

  before_validation lambda { self.start_at = Time.now if start_at.nil? }

  validates_presence_of :company_id, :end_at, :package_id, :start_at
  validate :double_activation
  validate :have_money

  def double_activation
    if CompaniesPackage.where(:company_id => company_id, :package_id => package_id).where('start_at > ?', Time.now - 5.seconds).any?
      errors.add(:base, 'Такой пакет только что активирован')
    end
  end

  def have_money
    errors.add(:base, :not_enough_money) if company.balance < sum
  end

  def months
    (end_at.year * 12 + end_at.month) - (start_at.year * 12 + start_at.month)
  end

  def sum
    months * package.price
  end

  def sum_with_nds
    sum * 1.18
  end

  # Коэфициент, показывающий насколько использован пакет (учёт в неделях)
  def usage_koef
    [(Date.today.cweek - start_at.to_date.cweek), 1].max / [end_at.to_date.cweek - start_at.to_date.cweek, 1].max.to_f
  end

  def previous
    CompaniesPackage.select('companies_packages.*').where(:company_id => company_id).joins(:package).where(:packages => { :ptype => package.ptype }).where('companies_packages.id != ?', id).last
  end

  after_create do 
    # # создаём счёт
    # Invoice.create(:sum => sum, :company_id => company_id, :status => :complete, :entity_type => self.class.to_s, :entity_id => id)
    # # деактивируем предыдущий пакет
    # if prev_companies_package = previous
    #   prev_companies_package.update_attribute(:end_at, start_at) if prev_companies_package.end_at > start_at
    #   # Создаём акт выполненных работ
    #   act = Act.create(:company_id => company_id, :sum => sum * usage_koef, :entity_id => self.id, :entity_type => self.class.to_s)
    #   # создаём счёт фактуру
    #   Facture.create(:company_id => company_id, :sum => sum * usage_koef, :act_id => act.id, :entity_id => self.id, :entity_type => self.class.to_s)
    # end
    Facture.create(:company_id => company_id, :sum => sum_with_nds, :entity_id => self.id, :entity_type => self.class.to_s)
  end

  def full_name
    package.full_name
  end
end
