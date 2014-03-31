# coding: utf-8

class FeedbacksController < ApplicationController

  #-----------------------------------------------------------------------------
  # Список отзывов
  #-----------------------------------------------------------------------------
  def index
    
    params[:category] = (params[:category]) ? params[:category] : nil
    
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category   => Category.get_child_id_by_alias(params[:category]),
      :type      => (params[:type]) ? "entity_type = '#{params[:type]}'"  : ''
    }

    #Основные запросы
    @feedbacks = Feedback.where(where[:category])
                         .where(where[:type])
                         .paginate(:page => params[:page], :per_page => query[:count])
                         .order(query[:sort] + ' ' + query[:order])
                
    #Второстепенные запросы
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @feedbacks }
    end
  end
  
  #--------------------------------------------------------------------------------
  # Добавление отзыва
  #--------------------------------------------------------------------------------
  def add
    
    @result = nil
    
    if user_signed_in?
      
      feedback_check = Feedback.where('user_id = ? AND entity_id = ? AND entity_type = ?', current_user.id, params[:feedback][:entity_id], params[:feedback][:entity_type])
    
      if feedback_check.count < 1
    
        @feedback = Feedback.new({
          :title => "-", 
          :plus => params[:feedback][:plus], 
          :minus => params[:feedback][:minus], 
          :comment => params[:feedback][:comment],
          :entity_type => params[:feedback][:entity_type],
          :entity_id => params[:feedback][:entity_id],
          :category_id => params[:feedback][:category_id],
          :user_id => current_user.id,
          :contentment => params[:feedback][:contentment]
        })
        
        if @feedback.save
          @result = 1
        else
          @result = []
          @feedback.errors.full_messages.each do |msg|
            @result << msg
          end
        end
        
      else
        @result = 3
      end
    
    else
      @result = 0
    end

    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
    
  end
  
end
