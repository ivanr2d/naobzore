class Site < ActiveRecord::Base
  CONSTRUCT_ATTRIBUTES = %w(header_image_background header_color_background header_logotype favicon internal_color_background external_color_background external_image_background menu_text_color menu_text_hover_color menu_background_color menu_background_hover_color menu_text_font_family menu_text_font_weight menu_text_font_style text_title_color text_title_font_family text_title_font_weight text_title_font_style text_content_color text_content_font text_content_weight text_content_style info_title_text_color info_title_background_color info_title_font info_title_weight info_title_style info_content_text_color info_content_background_color info_content_font info_content_weight info_content_style footer_text_color footer_background_color footer_font footer_weight footer_style).map(&:to_sym)

  def self.construct_defaults
    {
      :header_image_background => '/controlPanel/images/temp/textura2.jpg',
      :header_color_background => '#20cc20',
      :external_color_background => '#e9e9e9',
      :header_logotype => '/miniSite/images/temp/logo_kepler.png',
      :menu_text_color => '#fff',
      :menu_text_hover_color => '#01d6fd',
      :menu_background_color => '#838fa0',
      :menu_background_hover_color => '#e9e9e9',
      :menu_text_font_family => 'Arial',
      :menu_text_font_weight => 'normal',
      :menu_text_font_style => 'normal',
      :text_title_color => '#8490a1',
      :text_title_font_family => 'Verdana, sans-serif',
      :text_title_font_weight => 'normal',
      :text_title_font_style => 'normal',
      :text_content_color => '#000',
      :text_content_font => 'Verdana, sans-serif',
      :text_content_weight => 'normal',
      :text_content_style => 'normal',
      :info_title_text_color => '#fff',
      :info_title_background_color => '#838fa0',
      :info_content_background_color => '#fff',
      :info_content_text_color => '#141414',
      :footer_background_color => '#838fa0',
      :footer_text_color => '#ffffff'
    }
  end

  def self.uploader_fields
    {:header_image_background => HeaderImageUploader, :tmp_header_image_background => HeaderImageUploader, :header_logotype => HeaderLogotypeUploader, :tmp_header_logotype => HeaderLogotypeUploader, :favicon => FaviconUploader, :external_image_background => ExternalImageUploader, :tmp_external_image_background => ExternalImageUploader}
  end

  attr_accessible *(column_names + Site.uploader_fields.keys.map { |f| "remote_#{f}_url" })

  #validates :company_id, :presence => true
  validates :subdomen, :presence => true, :length => { :maximum => 64 }, :format => { :with => /^[\w\d-]+$/ }, :uniqueness => true

  belongs_to :company
  
  uploader_fields.each do |attr, uploader|
    mount_uploader attr, uploader
    attr_accessor "#{attr}_file_name".to_sym, "clear_#{attr}".to_sym
    ['', 'remove_', 'clear_'].each { |prefix| attr_accessible "#{prefix}#{attr}".to_sym }
  end

  before_save :clear_uploader_fields
  # TODO rewrite
  def clear_uploader_fields
    self.class.uploader_fields.keys.each do |key|
      if self.send("clear_#{key}".to_sym)
        ActiveRecord::Base.connection.execute("UPDATE sites SET #{key} = NULL WHERE id = #{self.id}")
      end
    end
  end

  before_save { self.title = self.subdomen if self.title.blank? }

  def self.url_with_subdomain subdomain, params = {}
    res = "http://#{subdomain}.#{CONFIG[:domain]}"
    res += '?' + params.to_query if params.any?
    res
  end
  
  def main_url params = {}
    Site.url_with_subdomain(subdomen, params)
  end

  # XXX если не добавить get_ к названию возникают конфликты с carrierwave
  CONSTRUCT_ATTRIBUTES.each do |a|
    define_method "get_#{a}" do |*args|
      res = send("tmp_#{a}".to_sym).to_s if construct_mode = args.first
      res = send(a).to_s if res.blank?
      res = self.class.construct_defaults[a].to_s if res.blank?
      res
    end
  end

  def header_background(construct_mode = false)
    return "url(#{tmp_header_image_background})" if tmp_header_image_background.present? && construct_mode
    return tmp_header_color_background if tmp_header_color_background.present? && construct_mode
    return header_color_background if header_color_background.present?
    "url(#{get_header_image_background})"
  end

  def external_background(construct_mode = false)
    return "url(#{tmp_external_image_background})" if tmp_external_image_background.present? && construct_mode
    return tmp_external_color_background if tmp_external_color_background.present? && construct_mode
    return external_color_background if external_color_background.present?
    "url(#{get_external_image_background})"
  end

  # Перенос значений из tmp_ полей в основные доступные пользователям
  def commit
    ActiveRecord::Base.connection.execute(
      'UPDATE sites SET ' + (CONSTRUCT_ATTRIBUTES.map { |attr| "#{attr} = IF(tmp_#{attr} IS NOT NULL, tmp_#{attr}, #{attr}), tmp_#{attr} = NULL" }.join(', ') ) + " WHERE id = #{self.id}"
    )
  end
  
  before_save do
    unless new_record?
      ActiveRecord::Base.connection.execute("UPDATE sites SET header_image_background = NULL, tmp_header_image_background = NULL WHERE id = #{id}") unless header_color_background.blank?
    end
    true
  end
end
