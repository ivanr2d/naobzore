# encoding: utf-8

class Minisite::NewsController < Minisite::BaseController
  before_filter :find_news, :only => [:show, :like, :ignore, :favorite]
  before_filter :add_meta
  include Likes

  def index
    @news = @company.news
    @news = @news.for_user(current_user) if user_signed_in?
    @news = @news.paginate(:page => params[:page] || 1, :per_page => 20)
    add_breadcrumb 'Новости'
  end

  def show
    add_breadcrumb 'Новости', '/news'
    add_breadcrumb @news.title 
  end

  private

  def find_news
    @entity = @news = @company.news.find_by_translit! params[:id]
  end
end
