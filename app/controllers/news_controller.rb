class NewsController < ApplicationController
  layout "layouts/simple_ext"
  
  def index

    params[:category] = (params[:category]) ? params[:category] : nil

    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category   => Category.get_child_id_by_alias(params[:category]),
    }
    

    #Основной запрос
    @news = News.where(where[:category])
                .paginate(:page => params[:page], :per_page => query[:count])
                .order(query[:sort] + ' ' + query[:order])
    
    #Второстепенные запросы
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    @categories = Category.where("cat_type = 'News'")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @goods }
    end
  end

  def show
    @news = News.find(params[:id])
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    @other_news = News.where('category_id = ?', @news.category_id).limit(6).order('id ASC')
    render :template => 'news/show', :layout => 'layouts/simple_ext_show'
  end
end