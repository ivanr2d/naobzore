# encoding: utf-8

class CompanyPanel::NewsController < CompanyPanel::EntitiesController
  skip_before_filter :prepare_notifications

  def initialize
    super
    @entity_type = 'News'
  end

  def new
    super
    @h1 = 'Добавление новости'
  end

  def create
    @entity = News.new(params[:entity])
    if @entity.save
      redirect_to '/company_panel', :notice => 'Добавлено'
    else
      render 'new'
    end
  end
end
