class GoodsController < ApplicationController
  # GET /goods
  # GET /goods.json
  # Project.joins(:customer).order('customers.name')
  def index

    params[:category] = (params[:category]) ? params[:category] : nil
    
    #Сортировка
    qr_count = (params[:count]) ? params[:count] : '10'
    qr_sort  = (params[:sort]) ? params[:sort] : 'created_at'
    qr_order = (params[:order]) ? params[:order] : 'DESC'
    
    #Фильтры
    where_category = Category.get_child_id(params[:category])
    where_maker = (params[:maker]) ? "maker = '#{params[:maker]}'"  : ''
    where_price_from = (params[:price_from]) ? 'price >= ' + params[:price_from] : ''
    where_price_to = (params[:price_to]) ? 'price <= ' + params[:price_to] : ''
    where_campaign = (params[:campaign]) ? 'campaign > 0' : ''

    #Основной запрос
    @goods = Good.where(where_category)
                .where(where_maker)
                .where(where_price_from)
                .where(where_price_to)
                .where(where_campaign)
                .paginate(:page => params[:page], :per_page => qr_count)
                .order(qr_sort + ' ' + qr_order)
    
    #Второстепенные запросы
    @makers = Maker.all
    @category = params[:category] != nil ? Category.find(params[:category]) : nil

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @goods }
    end
  end

  # GET /goods/1
  # GET /goods/1.json
  def show
    @good = Good.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @good }
    end
  end

  # GET /goods/new
  # GET /goods/new.json
  def new
    @good = Good.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @good }
    end
  end

  # GET /goods/1/edit
  def edit
    @good = Good.find(params[:id])
  end

  # POST /goods
  # POST /goods.json
  def create
    @good = Good.new(params[:good])

    respond_to do |format|
      if @good.save
        format.html { redirect_to @good, :notice => 'Good was successfully created.' }
        format.json { render :json => @good, :status => :created, :location => @good }
      else
        format.html { render :action => "new" }
        format.json { render :json => @good.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /goods/1
  # PUT /goods/1.json
  def update
    @good = Good.find(params[:id])

    respond_to do |format|
      if @good.update_attributes(params[:good])
        format.html { redirect_to @good, :notice => 'Good was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @good.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /goods/1
  # DELETE /goods/1.json
  def destroy
    @good = Good.find(params[:id])
    @good.destroy

    respond_to do |format|
      format.html { redirect_to goods_url }
      format.json { head :no_content }
    end
  end
  
  #Получение данных для POPUP
  def ajax
    
    @good = Good.find(params[:id])
    
    @result = [];
    @result[0] = @good
    @result[1] = @good.company
    @result[2] = @good.images
    
    if Visit.plus(params[:id], 'good', request.remote_ip)
      @good.views = (@good.views == nil) ? @good.views = 1 : @good.views + 1
      @good.save
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
  #-------------------------------------------------------
  # Переключение в попапе следующее/предыдущее
  #-------------------------------------------------------
  def switching
    
    params[:category] = (params[:category]) ? params[:category] : nil
    
    # Сортировка
    qr_count = (params[:count]) ? params[:count] : '10'
    qr_sort  = (params[:sort]) ? params[:sort] : 'created_at'
    qr_order = (params[:order]) ? params[:order] : 'DESC'
    
    # Фильтры
    where_category = ''
    
    # Проверяем есть ли дочерние категории
    if params[:category]
      temp = Category.get_child_id(params[:category])
      if temp != ''
        where_category = temp
      else
        where_category = 'category_id = ' + params[:category]
      end
    end

    where_maker = (params[:maker]) ? "maker = '#{params[:maker]}'"  : ''
    where_price_from = (params[:price_from]) ? 'price >= ' + params[:price_from] : ''
    where_price_to = (params[:price_to]) ? 'price <= ' + params[:price_to] : ''
    where_campaign = (params[:campaign]) ? 'campaign > 0' : ''

    # Получение всех айдишников с учетом сортировки и фильтров
    goods_id = Good.select('id, price').where(where_category)
                .where(where_maker)
                .where(where_price_from)
                .where(where_price_to)
                .where(where_campaign)
                .order(qr_sort + ' ' + qr_order)
    
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
      @result = [];
      @result[0] = @good
      @result[1] = @good.company
      @result[2] = @good.images
      
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
end


=begin
    if params[:order] == 'ASC'
      
      if params[:direction] == 'next'
        where_direction = 'id > ' + params[:id]
      elsif params[:direction] == 'prev'
        where_direction = 'id < ' + params[:id]
        params[:order] = 'DESC'
      end
      
    elsif params[:order] == 'DESC'
      
      if params[:direction] == 'next'
        where_direction = 'id < ' + params[:id]
      elsif params[:direction] == 'prev'
        where_direction = 'id > ' + params[:id]
        params[:order] = 'ASC'
      end
      
    end
    
    if @good.length > 0
      @result = [];
      @result[0] = @good[0]
      @result[1] = @good[0].company
      @result[2] = @good[0].images
      
      if Visit.plus(@good[0].id, 'good', request.remote_ip)
        @good.views = (@good[0].views == nil) ? @good[0].views = 1 : @good[0].views + 1
        @good[0].save
      end
    else
      @result = @good
    end
=end
