# coding: utf-8

class ResumeController < ApplicationController
  
  #----------------------------------------------------------------------------------
  # Список резюме
  #----------------------------------------------------------------------------------
  def index

    params[:category] = (params[:category]) ? params[:category] : nil
    
    query = {
      :count => (params[:count]) ? params[:count] : '10',
      :sort  => (params[:sort]) ? params[:sort] : 'created_at',
      :order => (params[:order]) ? params[:order] : 'DESC'
    }
    where = {
      :category => Category.get_child_id_by_alias(params[:category])
    }
    
    @resume = Resume.where(where[:category])
                .paginate(:page => params[:page], :per_page => query[:count])
                .order(query[:sort] + ' ' + query[:order])
    
    
    @probation_counts = [
      Job.where('probation = 0').count,
      Job.where('probation = 1').count
    ]
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @jobs }
    end
  end

  #----------------------------------------------------------------------------------
  # Обзор резюме
  #----------------------------------------------------------------------------------
  def show
    @resume = Resume.find(params[:id])
    @category = params[:category] != nil ? Category.find_by_alias(params[:category]) : nil
    @other_resume = Resume.where('category_id = ?', @resume.category_id).limit(6).order('id ASC')
    render :template => 'resume/show', :layout => 'layouts/simple_ext_show'
  end
end
