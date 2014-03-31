class MakeValidTranslits < ActiveRecord::Migration
  def initialize
    @models = [Good, Service, Job, Campaign, News]
  end

  def up
    @models.each do |model|
      puts model
      model.all.each do |entity|
        entity.update_attribute(:translit, Utils.url_translit(entity.translit))
      end
    end
  end

  def down
  end
end
