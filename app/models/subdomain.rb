class Subdomain < ActiveRecord::Base
  attr_accessible :company_id, :name

  validates :company_id, :presence => true, :numericality => true
  validates :name, :presence => true

  belongs_to :company

  default_scope order(:name)

  before_save :create_config

  def create_config
          text  = "    server {
	listen 80;
        server_name   #{name} www.#{name};

        location / {
          proxy_pass http://159.253.21.86:80/;
          proxy_set_header Host #{company.site.subdomen}.naobzore.ru;
          proxy_redirect off;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $remote_addr;
        }
    }"
     File.open("../conf/#{name}.conf", "w") do |f|
          f.write(text)
     end
  end
end
