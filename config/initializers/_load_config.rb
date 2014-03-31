CONFIG = YAML.load_file("#{Rails.root.to_s}/config/settings.yml")[Rails.env].symbolize_keys
CONFIG[:domain] = "#{CONFIG[:host]}#{CONFIG[:port] == 80 ? '' : ":#{CONFIG[:port]}"}"
CONFIG[:site] = "http://#{CONFIG[:domain]}"
