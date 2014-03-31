module HasPhoto
	extend ActiveSupport::Concern
  	included do
	    has_many :photos, :as => :entity, :dependent => :destroy
	end

	def main_photo
		photos.where(:main => true).first unless new_record?
	end

	def main_photo=(photo)
		if photo.is_a? Photo
			photo.update_attributes(:entity_id => id, :entity_type => self.class.to_s, :main => true)
		elsif photo
			photo = Photo.create(:company_id => company_id, :entity_id => id, :entity_type => self.class.to_s, :file => photo, :main => true)
		end
	end

	def photos= new_photos
		(photos - new_photos).each { |photo| photo.update_attributes(:entity_id => nil) }
		(new_photos - photos).each { |photo| photo.update_attributes(:entity_id => id, :entity_type => self.class.to_s) }
	end

	def possible_photos
	    photos = company.photos.where('entity_type = ?', self.class.to_s)
	    if new_record?
	      photos.where('entity_id IS NULL')
	    else
	      photos.where('entity_id IS NULL OR entity_id = ?', id)
	    end
	end
end