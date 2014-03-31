# coding: utf-8

class CompaniesController < ApplicationController

  #--------------------------------------------------------------------------------------
  # Список компаний
  #--------------------------------------------------------------------------------------
  def index

    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category   => '',
      :begin      => (params[:begin]) ? "name LIKE '#{params[:begin]}%'"  : ''
    }

    #Основной запрос
    @companies = Company.where(where[:category])
                        .where(where[:begin])
                        .paginate(:page => params[:page], :per_page => query[:count])
                        .order(query[:sort] + ' ' + query[:order])

    #Второстепенные запросы
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    @new_companies = Company.limit(10)
    
    #Вспомогательные данные
    @rus_letters = %{АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ}
    @eng_letters = %{ABCDEFGHIJKLMNOPQRSTUVWXWZ}
    @num_letters = %{1234567890}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @companies }
    end
  end

  #----------------------------------------------------------------------------------
  # По идее обзор компании
  #----------------------------------------------------------------------------------
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @company }
    end
  end

  #----------------------------------------------------------------------------------
  # Получение данных для POPUP
  #----------------------------------------------------------------------------------
  def ajax
    
    @company = Company.find(params[:id])
    @feedbacks = Feedback.where('entity_type = "Company" AND entity_id = ?', @company.id).limit(Feedback.get_limit()).order('id DESC')
    @default_delivery = Company.find_by_id(Settings.find_by_id(3).value.to_i)

    @result = []
    @result[0] = @company
    @result[1] = render_to_string("layouts/popup/company_header", :layout => false)
    @result[2] = render_to_string("layouts/popup/company_content", :layout => false)
    @result[3] = user_signed_in? ? render_to_string("layouts/popup/company_feedback", :layout => false) : ''
    
    if Visit.plus(params[:id], 'company', request.remote_ip)
      @company.views = (@company.views == nil) ? @company.views = 1 : @company.views + 1
      @company.save
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
  #-----------------------------------------------------------------------------------
  # Переключение компаний в POPUP
  #-----------------------------------------------------------------------------------
  def switching
    
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category   => '',
      :begin      => (params[:begin]) ? "name LIKE '#{params[:begin]}%'"  : ''
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
    companies_id = Company.select('id')
                          .where(where[:begin])
                          .order(query[:sort] + ' ' + query[:order])
                          #.where(where[:category])
    
    query_id = nil
    
    # Получение id запрашиваемой сущности
    i = 0
    companies_id.each do |company_id|
      if company_id.id.to_i == params[:id].to_i
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
    if companies_id[companies_id.count - 1].id.to_i == params[:id].to_i && params[:direction] == 'next'
      query_id = companies_id[0].id
    elsif companies_id[0].id.to_i == params[:id].to_i && params[:direction] == 'prev'
      query_id = companies_id[companies_id.count - 1].id
    else
      query_id = companies_id[i].id
    end
    
    @company = Company.find(query_id)
    @feedbacks = Feedback.where('entity_type = "Company" AND entity_id = ?', @company.id).limit(Feedback.get_limit()).order('id DESC')
    @default_delivery = Company.find_by_id(Settings.find_by_id(3).value.to_i)
    
    if @company

      @result = []
      @result[0] = @company
      @result[1] = render_to_string("layouts/popup/company_header", :layout => false)
      @result[2] = render_to_string("layouts/popup/company_content", :layout => false)
      @result[3] = user_signed_in? ? render_to_string("layouts/popup/company_feedback", :layout => false) : ''
      @result[10] = @company
      
      if Visit.plus(@company.id, 'company', request.remote_ip)
        @company.views = (@company.views == nil) ? @company.views = 1 : @company.views + 1
        @company.save
      end
    else
      @result = 0
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
end
