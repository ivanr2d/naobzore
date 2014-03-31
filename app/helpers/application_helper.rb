# encoding: utf-8

module ApplicationHelper
  
  #Для формы регистрации
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  #end | Для формы регистрации

  def render_error_explanation(object, msg = '')
    unless object.nil?
      @object = object
      @msg = msg
      render 'shared/error_explanation'
    end
  end

  def pluralize(count, one, two, five)
    "#{count} #{Russian::pluralize(count, one, two, five)}"
  end
  
  def parse_erb s
    ERB.new(s.to_s).result(binding)
  end

  def day_name number, short = false # monday - 0
    l (DateTime.now.beginning_of_week + number.days), :format => short ? '%a' : '%A'
  end

  def entity_path entity, params = {}
    send("#{entity.class.to_s.downcase}_path".to_sym, entity, params)
  end

  def entity_url entity, params = {}
    entity_path entity, params
  end

  def company_panel_entity_path entity, params = {}
    '/company_panel' + entity_path(entity, params)
  end

  def entity_comments_path entity, params = {}
    send("#{entity.class.to_s.downcase}_comments_path".to_sym, entity, params)
  end

  [:favorite, :ignore, :like].each do |op|
    define_method "#{op}_entity_path".to_sym do |entity, params = {}|
      send("#{op}_#{entity.class.to_s.downcase}_path".to_sym, entity, params)
    end
  end

  def entities_path(entity, params = {})
    send(entity.class.to_s.tableize + '_path', params)
  end
  
  def human_sex digit
    { 0 => 'Женский', 1 => 'Мужской' }[digit]
  end

  def url_for options = {}
    if @construct_mode
      case options
        when String
          if query = URI.parse(options).query
            unless query.include?('construct_mode=true')
              options += '&construct_mode=true'
            end
          else
            options += '?construct_mode=true'
          end
        when Hash
          options.merge!(:construct_mode => true)
      end
    end
    super options
  end

  # Если переданное количество больше нуля возсращает его в скобках
  def counter count
    " (#{count})" if count > 0
  end

  def copyright
    "© НаОбзоре.рф, #{Time.now.year}"
  end
end
