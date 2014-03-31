class Good < ActiveRecord::Base
  scope :with_campaign, select('goods.*').joins(:campaign)

  include Entity
  include ModelSociality

  belongs_to :warranty
  belongs_to :delivety
  belongs_to :folder

  # XXX выпилить использование метода title для товара и сам метод
	def title
		name
	end

end
