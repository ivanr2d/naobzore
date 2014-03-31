# encoding: utf-8

class Minisite::BaseController < ApplicationController
  before_filter :find_company_by_subdomain
  before_filter lambda { @site = @company.site }
  before_filter lambda { @construct_mode = !!params[:construct_mode] }

  layout 'minisite'

  def find_company_by_subdomain
    m = request.server_name.match(/^([\w\d\-]+)\.naobzore/)
    @company = Site.find_by_subdomen(m[1]).try(:company) || Subdomain.find_by_name(m[1]).try(:company)
    return render :text => 'Сайт не активирован' unless @company.status == :active
  end

  protected

  def add_meta
    if @entity
      meta :description, @entity.description        
      link :image_src, @entity.image_url
      meta :property => 'og:title', :content => @entity.name
      meta :property => 'og:description', :content => @entity.description
      meta :property => 'og:image', :content => @entity.image_url
      meta :property => 'og:url', :content => "http://#{request.domain}#/#{@entity.class.to_s.downcase}/#{@entity.id}"
    end
  end
end
