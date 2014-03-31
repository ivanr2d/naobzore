# encoding: UTF-8
module ModelSociality
  require 'uri'

  def social_share(social_project, share_url)
    social_project = social_project.to_sym
    @share_url = share_url

    social_share_template = Hash[*CONFIG[:socials].map{|e| e.to_a}.flatten][social_project.to_s]
    merged_hash = base_hash[social_project].deep_merge(custom_social_hash[social_project])

    case social_project
      when :vk
        merged_hash_event = CGI.unescape(merged_hash[:description]).gsub(/на.*/, "на #{URI(share_url).host}")
        merged_hash[:description] = CGI.escape(merged_hash_event)
        merged_hash[:url] = share_url
      when :twitter
        merged_hash_event = CGI.unescape(merged_hash[:text]).gsub(/на.*/, "на #{URI(share_url).host}")
        merged_hash[:text] = CGI.escape(merged_hash_event)
        merged_hash[:url] = share_url
      when :facebook
        merged_hash[:u] = share_url
      when :odnoklassniki
        merged_hash["st._surl"] = share_url
      when :lj
        str_to_gsub = "<a href='#{share_url}'>"
        merged_hash_event = CGI.unescape(merged_hash[:event]).gsub(/<a.*'>/, str_to_gsub) 
        merged_hash_event = merged_hash_event.gsub(/на.*<br><br>/, "на #{URI(share_url).host}<br><br>")  
        merged_hash[:event] = CGI.escape(merged_hash_event)
        merged_hash[:prop_taglist] = URI(share_url).host
      else
        merged_hash[:url] = share_url
    end    
    
    social_share_template.gsub /%\{data\}/, hash_to_uri_params(merged_hash)
  end

  protected
  
  # XXX убрать дублирования в base_hash и custom_social_hash
  def base_hash
    {
        :facebook => {
            :u => URI.escape(@share_url),
            :s => 100,
            :p => {
                :url => URI.escape(@share_url),
                :images => { # array of escaped urls
                },
                :title => nil,
                :summary => nil
            }
        },
        :twitter => {
            :url => URI.escape(@share_url),
            :text => nil
        },
        :vk => {
            :url =>  URI.escape(@share_url),
            :title => nil,
            :description => nil,
            :image => nil
        },
        :lj => {
            :mode => 'full',
            :event => URI.escape(I18n.t("likeable.#{self.class.to_s.underscore}")),
            :subject => nil,
            :prop_taglist => URI(@share_url).host,
            :url => URI.escape(@share_url)
        },
        :odnoklassniki => {
            'st.cmd' => 'addShare',
            'st.s' => 0,
            'st._surl' => URI.escape(@share_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")),
            'st.comments' => ''
        },
        :mailru => {
            :title => nil,
            :description => nil,
            :url => URI.escape(@share_url),
            :imageurl => nil,
        },
        :google => {
          :url => URI.escape(@share_url)
        }
    }
  end

  def custom_social_hash
    title = self.name
    url = URI.escape(entity_url(self))
    image = URI.escape(self.image_url.to_s)
    text = URI.escape("#{I18n.t("sharings.#{self.class.to_s.downcase}")} \"#{self.name}\" на #{URI(@share_url).host}")
    {
        :facebook => {
          :u => url
        },
        :twitter => {
          :text => text,
          :url => url
        },
        :vk => {
          :title => title,
          :url => url,
          :image => image,
          :description => text
        },
        :lj => {
          :subject => title,
          :url => url,
          :event => text
        },
        :odnoklassniki => {
          'st._surl' => url
        },
        :mailru => {
          :title => title,
          :url => url,
          :imageurl => image,
          :description => text
        },
        :google => {
          :url => url
        }
    }
  end

  def entity_url entity, host = URI(@share_url).host
    "http://#{host}/#{self.class.to_s.tableize}/#{self.id}"
  end

  private

  def hash_to_uri_params(hash)
    params = []
    hash.each do |key0, value0|
      if value0.is_a? Hash
        value0.each do |key1, value1|
          if value1.is_a? Hash
            value1.each do |key2, value2|
              params << "#{key0}[#{key1}][#{key2}]=#{value2}" if value2
            end
          else
            params << "#{key0}[#{key1}]=#{value1}" if value1
          end
        end
      else
        params << "#{key0}=#{value0}" if value0
      end
    end
    params.join('&')
  end
end
