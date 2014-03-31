class MoveEntitiesImagesToPhotos < ActiveRecord::Migration
  def up
    %w(Good Service Job Campaign News).each do |entity_type|
      photos = []
      entity_type.constantize.where('image IS NOT NULL and image != ""').each do |entity|
        if File.exists?(entity.image.path)
          if photo = Photo.create(:company_id => entity.company_id, :entity_id => entity.id, :entity_type => entity_type, :file => File.open(entity.image.path))
            photos << photo
            entity.remove_image!
            entity.save
          else
            photos.each { |photo| photo.destroy }
            raise "can not create photo for #{entity_type}##{entity.id}"
          end
        end
      end
    end
  end

  def down
  end
end
