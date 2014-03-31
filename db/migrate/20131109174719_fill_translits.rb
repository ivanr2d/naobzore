class FillTranslits < ActiveRecord::Migration
  def initialize
    @models = [Good, Service, Job, Campaign, News]
  end

  def up
    @models.each do |model|
      puts model
      model.unscoped.all.each do |entity|
        unless entity.update_attribute(:translit, Utils.translit(entity.name))
          puts "#{entity.class}##{entity.id} - #{entity.errors.full_messages.join(',')}"
        end
      end
    end
  end

  def down
  end
end
