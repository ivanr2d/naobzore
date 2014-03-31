class Service < ActiveRecord::Base
  include Entity
  include ModelSociality

  scope :with_campaign, select('services.*').joins(:campaign)

  belongs_to :warranty
  belongs_to :folder
end
