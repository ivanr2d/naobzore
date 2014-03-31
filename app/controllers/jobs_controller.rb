class JobsController < ApplicationController
  after_filter :save_statistics, :only => [:show]

  #----------------------------------------------------------------------------------------------
  # Список вакансий
  #----------------------------------------------------------------------------------------------
  def index

    params[:category] = (params[:category]) ? params[:category] : nil
    
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category    => Category.get_child_id_by_alias(params[:category]),
      :salary_from => (params[:salary_from]) ? 'salary_from >= ' + params[:salary_from] : '',
      :salary_to   => (params[:salary_to]) ? 'salary_to <= ' + params[:salary_to] : '',
      :graphic     => (params[:graphic]) ? 'graphic = ' + params[:graphic] : '',
      :probation   => (params[:probation]) ? 'probation = ' + params[:probation] : ''
    }
    
    @jobs = Job.where(where[:probation])
               .where(where[:category])
               .where(where[:salary_from])
               .where(where[:salary_to])
               .where(where[:graphic])
               .paginate(:page => params[:page], :per_page => query[:count])
               .order(query[:sort] + ' ' + query[:order])
    
    
    @probation_counts = [
      Job.where('probation = 0').count,
      Job.where('probation = 1').count
    ]
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    @max_salary = Job.select('salary_to').where(where[:probation]).where(where[:category]).where(where[:graphic]).maximum('salary_to')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @jobs }
    end
  end

  #--------------------------------------------------------------------------------------------
  # Обзор вакансии
  #--------------------------------------------------------------------------------------------
  def show
    @job = Job.find(params[:id])
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    @feedbacks = Feedback.where('entity_type = "Job" AND entity_id = ?', @job.id).limit(Feedback.get_limit()).order('id DESC')
    
    @other_jobs = Job.where('category_id = ?', @job.category_id).limit(6).order('id ASC')
    render :template => 'jobs/show', :layout => 'layouts/simple_ext_show'
  end
  
  #--------------------------------------------------------------------------------------------
  # Получение данных для POPUP
  #--------------------------------------------------------------------------------------------
  def ajax
    
    @job = Job.find(params[:id])
    @feedbacks = Feedback.where('entity_type = "Job" AND entity_id = ?', @job.id).limit(Feedback.get_limit()).order('id DESC')
    
    @result = []
    @result[0] = @job.company
    @result[1] = render_to_string("layouts/popup/job_header", :layout => false)
    @result[2] = render_to_string("layouts/popup/job_content", :layout => false)
    #@result[3] = user_signed_in? ? render_to_string("layouts/popup/job_feedback", :layout => false) : ''
    
    if Visit.plus(params[:id], 'job', request.remote_ip)
      @job.views = (@job.views == nil) ? @job.views = 1 : @job.views + 1
      @job.save
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
  #------------------------------------------------------------------------------------------------
  # Переключение в попапе следующее/предыдущее
  #------------------------------------------------------------------------------------------------
  def switching
    
    params[:category] = (params[:category]) ? params[:category] : nil

    query = {
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category    => '',
      :salary_from => (params[:salary_from]) ? 'salary_from >= ' + params[:salary_from] : '',
      :salary_to   => (params[:salary_to]) ? 'salary_from <= ' + params[:salary_to] : '',
      :graphic     => (params[:graphic]) ? 'graphic = ' + params[:graphic] : '',
      :probation   => (params[:probation]) ? 'probation = ' + params[:probation] : ''
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
    jobs_id = Job.select(:id)
                 .where(where[:category])
                 .where(where[:probation])
                 .where(where[:salary_from])
                 .where(where[:salary_to])
                 .where(where[:graphic])
                 .order(query[:sort] + ' ' + query[:order])
    
    query_id = nil
    
    # Получение id запрашиваемой сущьности
    i = 0
    jobs_id.each do |job_id|
      if job_id.id.to_i == params[:id].to_i
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
    if jobs_id[jobs_id.count - 1].id.to_i == params[:id].to_i && params[:direction] == 'next'
      query_id = jobs_id[0].id
    elsif jobs_id[0].id.to_i == params[:id].to_i && params[:direction] == 'prev'
      query_id = jobs_id[jobs_id.count - 1].id
    else
      query_id = jobs_id[i].id
    end
    
    @job = Job.find(query_id)
    
    if @job
      
      @result = []
      @result[0] = @job.company
      @result[1] = render_to_string("layouts/popup/job_header", :layout => false)
      @result[2] = render_to_string("layouts/popup/job_content", :layout => false)
      @result[10] = @job
      
      if Visit.plus(@job.id, 'job', request.remote_ip)
        @job.views = (@job.views == nil) ? @job.views = 1 : @job.views + 1
        @job.save
      end
    else
      @result = 0
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
 
	private

  def save_statistics
    Statistic.create(:entity_id => @job.id, :entity_type => 'Job', :user_id => current_user.try(:id), :ip => request.remote_ip)
  end 
end
