class CompaniesMenu < ActiveRecord::Base
  attr_accessible :company_id, :menu_id, :pos

  belongs_to :company
  belongs_to :menu
end
