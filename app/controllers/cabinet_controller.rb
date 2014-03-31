class CabinetController < ApplicationController

  before_filter :authenticate_user!, :only => [:index]
  before_filter :cabinet_init
  
  def cabinet_init
    @user = User.find(current_user.id)
    
    # Сущности для левого блока
    @left_entities = {
      :goods => {
        :entities => Favorite.where("entity_type = 'Good'").limit(6).order('created_at DESC'),
        :count => Favorite.where("entity_type = 'Good'").count
      },
      :services => {
        :entities => Favorite.where("entity_type = 'Service'").limit(6).order('created_at DESC'),
        :count => Favorite.where("entity_type = 'Service'").count
      },
      :jobs => {
        :entities => Favorite.where("entity_type = 'Job'").limit(6).order('created_at DESC'),
        :count => Favorite.where("entity_type = 'Job'").count
      },
      :companies => {
        :entities => Favorite.where("entity_type = 'Company'").limit(6).order('created_at DESC'),
        :count => Favorite.where("entity_type = 'Company'").count
      },
      :campaigns => {
        :entities => Favorite.where("entity_type = 'Campaign'").limit(6).order('created_at DESC'),
        :count => Favorite.where("entity_type = 'Campaign'").count
      },
    }
  end
  
  # Главная страница кабинета
  #
  #
  #
  def index
    
    @my_cabinet = true
    
    where = {
      :types => ''
    }
    
    @filter = {
      view: nil
    }

    #Фильтр на тип сущности
    if !cookies[:filter_view]
      cookies[:filter_view] = 'Good:Service:Job:Company:News:Campaign:Feedback:Ads'
      @filter[:view] = cookies[:filter_view].split(':')
    else
      @filter[:view] = cookies[:filter_view].split(':')
    end
    
    @filter[:view].each do |type|
      where[:types] += 'entity_type = \'' + type + '\' OR '
    end
    
    where[:types] = where[:types][0, where[:types].length - 4]
    #end | Фильтр на тип сущности
    
    #Остновние запросы
    @favorites = Favorite.where(where[:types]).paginate(:page => params[:page], :per_page => 15).order('created_at DESC')
    
    render 'index', :layout => 'user_cabinet'
  end
  
  #Вывод сущностей по типу
  #
  #
  def entities
    
    @my_cabinet = true
    
    @favorites = Favorite.where('entity_type = ?', params[:type]).paginate(:page => params[:page], :per_page => 15).order('created_at DESC')
    @count = @favorites.count
    @mini_title = ''
    
    Common.types.each do |type|
      if type[1] == params[:type].capitalize
        @mini_title = type[0]
      end
    end
    
    render 'entities', :layout => 'user_cabinet'
  end
  
  #Даннык для попапа
  #
  #
  #
  def ajax
    @favorite = Favorite.where(:entity_id => params[:id]).where(:entity_type => params[:type])
    
    @result = [];
    
    if params[:type] != 'company'
      @result[0] = @favorite[0].entity
      @result[1] = @favorite[0].entity.company
      @result[2] = @favorite[0].entity.images
    else
      @result[0] = @favorite[0].entity
      @result[2] = @favorite[0].entity.images
    end
    
    if Visit.plus(params[:id], params[:type], request.remote_ip)
      @favorite[0].entity.views = (@favorite[0].entity.views == nil) ? @favorite[0].entity.views = 1 : @favorite[0].entity.views = @favorite[0].entity.views.to_i + 1
      @favorite[0].entity.save
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
  #Переключение сущностей в попапе
  #
  #
  #
  def switching
    
    query_id = nil
    @result  = []
    
    if params[:type_one] == "false"
      favorites_id = Favorite.select('id, entity_id, entity_type').where(Favorite.sql_types(cookies[:filter_view].split(':'))).order('created_at DESC')
    else
      favorites_id = Favorite.select('id, entity_id, entity_type').where(Favorite.sql_types([params[:type]])).order('created_at DESC')
    end
    
    # Получение id запрашиваемой сущности
    i = 0
    favorites_id.each do |favorite_id|
      if favorite_id.entity_id.to_i == params[:id].to_i && favorite_id.entity_type == params[:type].capitalize
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
    if favorites_id[favorites_id.count - 1].entity_id.to_i == params[:id].to_i && params[:direction] == 'next'
      query_id = favorites_id[0].id # ПЕРВЫЙ
    elsif favorites_id[0].entity_id.to_i == params[:id].to_i && params[:direction] == 'prev'
      query_id = favorites_id[favorites_id.count - 1].id # ПОСЛЕДНИЙ
    else
      query_id = favorites_id[i].id
    end
    
    #query_id = favorites_id[i].id
    
    @favorite = Favorite.find(query_id)
    
    # Подготовка данных для попапа
    if @favorite
      @result[0] = @favorite.entity
      @result[1] = (@favorite.entity_type != 'Company') ? @favorite.entity.company : nil
      @result[2] = @favorite.entity.images
      @result[3] = @favorite.entity_type.downcase!
      
      if Visit.plus(@favorite.entity.id, @favorite.entity_type, request.remote_ip)
        @favorite.entity.views = (@favorite.entity.views == nil) ? @favorite.entity.views = 1 : @favorite.entity.views + 1
        @favorite.entity.save
      end
    else
      @result = 0
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
end