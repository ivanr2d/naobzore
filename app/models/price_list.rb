# encoding: utf-8

class PriceList < ActiveRecord::Base
  attr_accessible :company_id, :xls, :note_missed_entities, :refreshed_fields

  validates_presence_of :company_id, :xls

  mount_uploader :xls, XlsUploader
  attr_accessor :xls_file_name

  has_many :price_entities
  belongs_to :price_list

  after_create :parse_xls

  def parse_xls
    require 'spreadsheet'
    require 'open-uri'
    Spreadsheet.client_encoding = 'UTF-8'

    Spreadsheet.open(xls.path) do |book|
      # parse groups (folders in db)
      columns = %w(number name id parent_number parent_id)
      book.worksheet(1).each_with_index do |row, index|
        if index == 0
          return unless  row.count == columns.count
        elsif row.to_a.compact.count > 0
          folder_hash = Hash[columns.zip(row.to_a)]
          folder = Folder.find_or_initialize_by_id folder_hash['id']
          %w(number name parent_id).each { |c| folder.send("#{c}=", folder_hash[c]) }
          folder.company_id = company_id
          folder.save
          Folder.find_by_id(folder_hash['parent_id']).try(:update_attribute, :number, folder_hash['parent_number'])
        end
      end

      # parse entities
      columns = PriceEntity.price_columns
      book.worksheet(0).each_with_index do |row, index|
        if index == 0
          return unless row.count == columns.count
        elsif row.to_a.compact.count > 0
          params = Hash[columns.zip(row.to_a)].symbolize_keys

          characteristics_str = params.delete(:characteristics).to_s
          price_entity = PriceEntity.new(params)
          price_entity.company_id = company_id
          price_entity.price_list_id = id
          # В прайсе number а не id группы
          price_entity.folder_id = Folder.find_by_number(price_entity.folder_id).try(:id) if price_entity.folder_id
          price_entity.save(:validate => false)
          # Сохраняем характеристики
          price_entity.characteristics = characteristics_str.split('#').map { |c| Characteristic.new(:key => c.split(':').first, :value => c.split(':').last) if c.include?(':') }.compact
        end
      end
    end
  end

  def export entities
    # move price entities to goods and services
    @good_ids = [0]
    @service_ids = [0]
    errors = []
    entities.each do |price_entity|
      category = price_entity.category
      entity_class = category.cat_type == 'Service' ? Service : Good
      # refresh entity
      if res_entity = entity_class.send(:with_exclusive_scope) { entity_class.where(:company_id => company_id).find_by_article(price_entity.article) } and !res_entity.deleted_at
        refreshed_fields.to_s.split(',').each do |refreshed_field|
          if refreshed_field == 'image'
            if price_entity.image.url.index('http') == 0
              res_entity.remote_image_url = price_entity.image
            else
              res_entity.image = price_entity.image
            end
            res_entity.photos = price_entity.photos
          else
            res_entity.send("#{refreshed_field}=", price_entity.send(refreshed_field.to_sym))
          end
        end
        if res_entity.save
          price_entity.destroy
        else
          errors += res_entity.errors.full_messages
        end
      # create new entity
      else
        res_entity.destroy if res_entity.try(:deleted_at)
        res_entity = entity_class.new
        (PriceEntity.column_names & entity_class.column_names).delete_if { |c| %w(id created_at updated_at).include?(c) }.each do |column|
          if column == 'image'
            if price_entity.image.url.to_s.index('http') == 0
              res_entity.remote_image_url = price_entity.image_url
            else
              res_entity.image = price_entity.image
            end
          else
            res_entity.send("#{column}=", price_entity.send(column.to_sym))
          end
        end
        if res_entity.is_a?(Service)
          res_entity.cost_from = res_entity.cost_to = price_entity.price
        else
          res_entity.title = price_entity.name
        end
        if res_entity.save
          res_entity.photos = price_entity.photos
          price_entity.characteristics.update_all(:entity_id => res_entity.id, :entity_type => res_entity.class.to_s)
          price_entity.destroy
        else
          errors += res_entity.errors.full_messages
        end
      end
      
      # entities whish doesn't exist more in price
      variable = "@#{entity_class.to_s.downcase}_ids"
      instance_variable_get(variable).push(res_entity.id)
    end
    if note_missed_entities == :unpublished
      ActiveRecord::Base.connection.execute(
        "UPDATE goods SET published = 0 WHERE company_id = #{company_id} AND id NOT IN (#{@good_ids.join(',')})"
      )
      ActiveRecord::Base.connection.execute(
        "UPDATE services SET published = 0 WHERE company_id = #{company_id} AND id NOT IN (#{@service_ids.join(',')})"
      )
    elsif note_missed_entities == :deleted
      ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array, [
        "UPDATE goods SET deleted_at = ? WHERE company_id = #{company_id} AND id NOT IN (#{@good_ids.join(',')})", Time.now 
      ]))
      ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array, [
        "UPDATE services SET deleted_at = ? WHERE company_id = #{company_id} AND id NOT IN (#{@service_ids.join(',')})", Time.now
      ]))
    end

    if errors.flatten.any?
      errors.flatten.uniq.each { |e| self.errors.add(:base, e) }
      false
    else
      true
    end
  end
end
