class GoodsController < ApplicationController
  # TODO save statistics for any other actions
  after_filter :save_statistics, :only => [:show]

  #---------------------------------------------------------------------------------------------
  # Список товаров
  #---------------------------------------------------------------------------------------------
  def index

    params[:category] = (params[:category]) ? params[:category] : nil
    
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category   => Category.get_child_id_by_alias(params[:category]),
      :maker      => (params[:maker]) ? "maker = '#{params[:maker]}'"  : '',
      :price_from => (params[:price_from]) ? 'price >= ' + params[:price_from] : '',
      :price_to   => (params[:price_to]) ? 'price <= ' + params[:price_to] : '',
      :campaign   => (params[:campaign]) ? 'campaign_id != NULL' : ''
    }

    #Основной запрос
    @goods = Good.where(where[:category])
                 .where(where[:maker])
                 .where(where[:price_from])
                 .where(where[:price_to])
                 .where(where[:campaign])
                 .paginate(:page => params[:page], :per_page => query[:count])
                 .order(query[:sort] + ' ' + query[:order])
    
    #Второстепенные запросы
    @makers = Maker.all
    @max_price = Good.select('price_to').where(where[:category]).where(where[:maker]).where(where[:campaign]).maximum('price');
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @goods }
    end
  end

  #------------------------------------------------------------------------------------------------
  # Обзор товара
  #------------------------------------------------------------------------------------------------
  def show
    @good = Good.find(params[:id])
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    @feedbacks = Feedback.where('entity_type = "Good" AND entity_id = ?', @good.id).limit(Feedback.get_limit()).order('id DESC')
    @default_delivery = Company.find_by_id(Settings.find_by_id(3).value.to_i)
    
    @other_goods = Good.where('category_id = ?', @good.category_id).limit(6).order('id ASC')
    render :template => 'goods/show', :layout => 'layouts/simple_ext_show'
  end
  
  #-------------------------------------------------------------------------------------------------
  #Получение данных для POPUP
  #-------------------------------------------------------------------------------------------------
  def ajax
    
    @good = Good.find(params[:id])
    @feedbacks = Feedback.where('entity_type = "Good" AND entity_id = ?', @good.id).limit(Feedback.get_limit()).order('id DESC')
    @default_delivery = Company.find_by_id(Settings.find_by_id(3).value.to_i)
    
    @result = []
    @result[0] = @good.company
    @result[1] = render_to_string("layouts/popup/good_header", :layout => false)
    @result[2] = render_to_string("layouts/popup/good_content", :layout => false)
    @result[3] = user_signed_in? ? render_to_string("layouts/popup/good_feedback", :layout => false) : ''
    
    if Visit.plus(params[:id], 'good', request.remote_ip)
      @good.views = (@good.views == nil) ? @good.views = 1 : @good.views + 1
      @good.save
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
  #------------------------------------------------------------------------------------------------
  # Переключение в попапе следующее/предыдущее
  #------------------------------------------------------------------------------------------------
  def switching
    
    params[:category] = (params[:category]) ? params[:category] : nil
    
    # Сортировка
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category   => '',
      :maker      => (params[:maker]) ? "maker = '#{params[:maker]}'"  : '',
      :price_from => (params[:price_from]) ? 'price >= ' + params[:price_from] : '',
      :price_to   => (params[:price_to]) ? 'price <= ' + params[:price_to] : '',
      :campaign   => (params[:campaign]) ? 'campaign > 0' : ''
    }
    
    # Проверяем есть ли дочерние категории
    if params[:category]
      temp = Category.get_child_id_by_alias(params[:category])
      if temp != ''
        where[:category] = temp
      else
        where[:category] = 'category_id = ' + params[:category]
      end
    end

    # Получение всех айдишников с учетом сортировки и фильтров
    goods_id = Good.select('id, price')
                   .where(where[:category])
                   .where(where[:maker])
                   .where(where[:price_from])
                   .where(where[:price_to])
                   .where(where[:campaign])
                   .order(query[:sort] + ' ' + query[:order])
    
    query_id = nil
    
    # Получение id запрашиваемой сущности
    i = 0
    goods_id.each do |good_id|
      if good_id.id.to_i == params[:id].to_i
        if params[:direction] == 'next'
          i += 1
        elsif params[:direction] == 'prev'
          i -= 1
        end
        break
      end
      i += 1
    end
    # теперь у нас есть id
    
    # В случии отсутствия следующей или предыдущей сущности
    # в результат выдаем либо первую либо последнюю сущность в зависимости от направления
    if goods_id[goods_id.count - 1].id.to_i == params[:id].to_i && params[:direction] == 'next'
      query_id = goods_id[0].id
    elsif goods_id[0].id.to_i == params[:id].to_i && params[:direction] == 'prev'
      query_id = goods_id[goods_id.count - 1].id
    else
      query_id = goods_id[i].id
    end

    @good = Good.find(query_id)
    
    # Подготовка данных для попапа
    if @good
      @feedbacks = Feedback.where('entity_type = "Good" AND entity_id = ?', @good.id).limit(Feedback.get_limit()).order('id DESC')
      @default_delivery = Company.find_by_id(Settings.find_by_id(3).value.to_i)
      
      @result = []
      @result[0] = @good.company
      @result[1] = render_to_string("layouts/popup/good_header", :layout => false)
      @result[2] = render_to_string("layouts/popup/good_content", :layout => false)
      @result[3] = user_signed_in? ? render_to_string("layouts/popup/good_feedback", :layout => false) : ''
      @result[10] = @good
      
      if Visit.plus(@good.id, 'good', request.remote_ip)
        @good.views = (@good.views == nil) ? @good.views = 1 : @good.views + 1
        @good.save
      end
    else
      @result = 0
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end

  private

  def save_statistics
    Statistic.create(:entity_id => @good.id, :entity_type => 'Good', :user_id => current_user.try(:id), :ip => request.remote_ip)
  end
end
