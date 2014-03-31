# coding: utf-8

class CampaignsController < ApplicationController
  after_filter :save_statistics, :only => [:show]

  #--------------------------------------------------------------------------------
  # Список акций
  #--------------------------------------------------------------------------------
  def index
  
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category   => Category.get_child_id_by_alias(params[:category])
    }


    #Основные запросы
    @campaigns = Campaign.where(where[:category])
                         .paginate(:page => params[:page], :per_page => query[:count])
                         .order(query[:sort] + ' ' + query[:order])

    #Второстепенные запросы
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @campaigns }
    end
  end

  #------------------------------------------------------------------------------------
  # Обзор акции
  #------------------------------------------------------------------------------------
  def show
    @campaign = Campaign.find(params[:id])
    @feedbacks = Feedback.where('entity_type = "Campaign" AND entity_id = ?', @campaign.id).limit(Feedback.get_limit()).order('id DESC')
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    
    @other_campaign = Campaign.where('category_id = ?', @campaign.category_id).limit(6).order('id ASC')
    render :template => 'campaigns/show', :layout => 'layouts/simple_ext_show'
  end

  #------------------------------------------------------------------------------------  
  # Получение данных для POPUP
  #------------------------------------------------------------------------------------
  def ajax
    
    @campaign = Campaign.find(params[:id])
    @feedbacks = Feedback.where('entity_type = "Campaign" AND entity_id = ?', @campaign.id).limit(Feedback.get_limit()).order('id DESC')

    @result = []
    @result[0] = @campaign.company
    @result[1] = render_to_string("layouts/popup/campaign_header", :layout => false)
    @result[2] = render_to_string("layouts/popup/campaign_content", :layout => false)
    @result[3] = user_signed_in? ? render_to_string("layouts/popup/campaign_feedback", :layout => false) : ''
    
    if Visit.plus(params[:id], 'campaign', request.remote_ip)
      @campaign.views = (@campaign.views == nil) ? @campaign.views = 1 : @campaign.views + 1
      @campaign.save
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
  #-------------------------------------------------------------------------------------
  # Переключение в попапе следующее/предыдущее
  #-------------------------------------------------------------------------------------
  def switching
    
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category => ''
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
    campaigns_id = Campaign.select('id')
                           .where(where[:category])
                           .order(query[:sort] + ' ' + query[:order])
                
    query_id = nil
    
    # Получение id запрашиваемой сущьности
    i = 0
    campaigns_id.each do |campaign_id|
      if campaign_id.id.to_i == params[:id].to_i
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
    if campaigns_id[campaigns_id.count - 1].id.to_i == params[:id].to_i && params[:direction] == 'next'
      query_id = campaigns_id[0].id
    elsif campaigns_id[0].id.to_i == params[:id].to_i && params[:direction] == 'prev'
      query_id = campaigns_id[campaigns_id.count - 1].id
    else
      query_id = campaigns_id[i].id
    end
    
    @campaign = Campaign.find(query_id)
    @feedbacks = Feedback.where('entity_type = "Campaign" AND entity_id = ?', @campaign.id).limit(Feedback.get_limit()).order('id DESC')
    
    if @campaign

      @result = []
      @result[0] = @campaign.company
      @result[1] = render_to_string("layouts/popup/campaign_header", :layout => false)
      @result[2] = render_to_string("layouts/popup/campaign_content", :layout => false)
      @result[3] = user_signed_in? ? render_to_string("layouts/popup/campaign_feedback", :layout => false) : ''
      @result[10] = @campaign
      
      if Visit.plus(@campaign.id, 'campaign', request.remote_ip)
        @campaign.views = (@campaign.views == nil) ? @campaign.views = 1 : @campaign.views + 1
        @campaign.save
      end
    else
      @result = 0
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
 
	private

  def save_statistics
    Statistic.create(:entity_id => @campaign.id, :entity_type => 'Campaign', :user_id => current_user.try(:id), :ip => request.remote_ip)
  end
end
