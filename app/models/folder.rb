class Folder < ActiveRecord::Base
	ENTITY_TYPES = [:goods, :services, :campaigns]

	attr_accessible :company_id, :name, :number

	belongs_to :company
	ENTITY_TYPES.each { |entity_type| has_many entity_type, :dependent => :nullify }
	default_scope order(:name)

	validates :name, :presence => true
	validates :number, :presence => true, :uniqueness => { :scope => :company_id }

	before_validation lambda { self.number = Folder.select('MAX(number) AS number').first.try(:number).to_i + 1 unless number }

	def entities
		ENTITY_TYPES.inject([]) { |res, entity_type| res + self.send(entity_type) }
	end
end
