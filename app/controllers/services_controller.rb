class ServicesController < ApplicationController
  after_filter :save_statistics, :only => [:show]
	
  #----------------------------------------------------------------------------------
  # Список услуг
  #----------------------------------------------------------------------------------
  def index

    params[:category] = (params[:category]) ? params[:category] : nil
    
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category   => Category.get_child_id_by_alias(params[:category]),
      :cost_from  => (params[:cost_from]) ? 'price >= ' + params[:cost_from] : '',
      :cost_to    => (params[:cost_to]) ? 'price <= ' + params[:cost_to] : '',
      :campaign   => (params[:campaign]) ? 'campaign_id != NULL' : ''
    }
    
    @services = Service.where(where[:category])
                       .where(where[:cost_from])
                       .where(where[:cost_to])
                       .where(where[:campaign])
                       .paginate(:page => params[:page], :per_page => query[:count])
                       .order(query[:sort] + ' ' + query[:order])
                       
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    @max_cost = Service.select('price').where(where[:category]).where(where[:campaign]).maximum('price')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @services }
    end
  end

  #----------------------------------------------------------------------------------
  # Обзор услуги
  #----------------------------------------------------------------------------------
  def show
    @service = Service.find(params[:id])
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    @feedbacks = Feedback.where('entity_type = "Service" AND entity_id = ?', @service.id).limit(Feedback.get_limit()).order('id DESC')
    
    @other_services = Service.where('category_id = ?', @service.category_id).limit(6).order('id ASC')
    render :template => 'services/show', :layout => 'layouts/simple_ext_show'
  end
  
  #----------------------------------------------------------------------------------
  # Получение данных для POPUP
  #----------------------------------------------------------------------------------
  def ajax
    
    @service = Service.find(params[:id])
    @feedbacks = Feedback.where('entity_type = "Service" AND entity_id = ?', @service.id).limit(Feedback.get_limit()).order('id DESC')
    
    @result = []
    @result[0] = @service.company
    @result[1] = render_to_string("layouts/popup/service_header", :layout => false)
    @result[2] = render_to_string("layouts/popup/service_content", :layout => false)
    @result[3] = user_signed_in? ? render_to_string("layouts/popup/service_feedback", :layout => false) : ''
    
    if Visit.plus(params[:id], 'service', request.remote_ip)
      @service.views = (@service.views == nil) ? @service.views = 1 : @service.views + 1
      @service.save
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
  #-------------------------------------------------------------------------------
  # Переключение в попапе следующее/предыдущее
  #-------------------------------------------------------------------------------
  def switching

    params[:category] = (params[:category]) ? params[:category] : nil
    
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category   => '',
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
    services_id = Service.select('id')
                         .where(where[:category])
                         .where(where[:price_from])
                         .where(where[:price_to])
                         .where(where[:campaign])
                         .order(query[:sort] + ' ' + query[:order])
    
    query_id = nil
    
    # Получение id запрашиваемой сущьности
    i = 0
    services_id.each do |service_id|
      if service_id.id.to_i == params[:id].to_i
        if params[:direction] == 'next'
          i += 1
        elsif params[:direction] == 'prev'
          i -= 1
        end
        break
      end
      i += 1
    end #теперь у нас есть id
    
    # В случии отсутствия следующей или предыдущей сущности
    # в результат выдаем либо первую либо последнюю сущьность в щависимости от направления
    if services_id[services_id.count - 1].id.to_i == params[:id].to_i && params[:direction] == 'next'
      query_id = services_id[0].id
    elsif services_id[0].id.to_i == params[:id].to_i && params[:direction] == 'prev'
      query_id = services_id[services_id.count - 1].id
    else
      query_id = services_id[i].id
    end
    
    @service = Service.find(query_id)
    @feedbacks = Feedback.where('entity_type = "Service" AND entity_id = ?', @service.id).limit(Feedback.get_limit()).order('id DESC')
    
    if @service
      
      @result = []
      @result[0] = @service.company
      @result[1] = render_to_string("layouts/popup/service_header", :layout => false)
      @result[2] = render_to_string("layouts/popup/service_content", :layout => false)
      @result[3] = user_signed_in? ? render_to_string("layouts/popup/service_feedback", :layout => false) : ''
      @result[10] = @service
      
      if Visit.plus(@service.id, 'service', request.remote_ip)
        @service.views = (@service.views == nil) ? @service.views = 1 : @service.views + 1
        @service.save
      end
    else
      @result = 0
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end

	private

  def save_statistics
    Statistic.create(:entity_id => @service.id, :entity_type => 'Service', :user_id => current_user.try(:id), :ip => request.remote_ip)
  end
  
end
