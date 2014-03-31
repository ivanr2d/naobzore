class Menu < ActiveRecord::Base
  attr_accessible :name

  has_many :companies_menus
  has_many :companies, :through => :companies_menus

  def entities
    if (e = path.gsub(/^\/|\/$/, '')).present? && (e.classify.constantize rescue false)
      e.to_sym
    end
  end
end
