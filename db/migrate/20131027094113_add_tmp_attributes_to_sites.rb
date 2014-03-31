class AddTmpAttributesToSites < ActiveRecord::Migration
  def initialize
    @attributes = %w(header_color_background header_logotype favicon internal_color_background external_color_background menu_text_color menu_text_hover_color menu_background_color menu_background_hover_color menu_text_font_family menu_text_font_weight menu_text_font_style text_title_color text_title_font_family text_title_font_weight text_title_font_style text_content_color text_content_font text_content_weight text_content_style info_title_text_color info_title_background_color info_title_font info_title_weight info_title_style info_content_text_color info_content_background_color info_content_font info_content_weight info_content_style footer_text_color footer_background_color footer_font footer_weight footer_style)
  end

  def up
    change_table :sites do |t|
      @attributes.each do |a|
        t.string "tmp_#{a}".to_sym, :after => a.to_sym
      end
    end
  end

  def down
    change_table :sites do |t|
      @attributes.each do |a|
        t.remove "tmp_#{a}".to_sym
      end
    end
  end
end
