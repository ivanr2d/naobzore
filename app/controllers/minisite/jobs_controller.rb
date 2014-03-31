# encoding: utf-8

class Minisite::JobsController < Minisite::BaseController
  before_filter :find_job, :only => [:show, :like, :ignore, :favorite]
  before_filter :add_meta
  include Likes

  def index
    @salary_from = @company.jobs.select('min(salary_from) as salary_from').first.salary_from
    @salary_to = @company.jobs.select('max(salary_to) as salary_to').first.salary_to
    @jobs = @company.jobs
    @jobs = @jobs.where('salary_to >= :f OR (salary_to IS NULL AND salary_from >= :f)', :f => params[:salary_from]) if params[:salary_from]
    @jobs = @jobs.where('salary_from <= ?', params[:salary_to]) if params[:salary_to]
    @jobs = @jobs.where(:graphic_id => params[:graphic_id]) if params[:graphic_id]
    @jobs = @jobs.for_user(current_user) if user_signed_in?
    @jobs = @jobs.order(case params[:order]
      when 'comments_count' then 'comments_count'
      when 'views' then 'views'
      else 'salary_from'
    end)
    @jobs = @jobs.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 20)
    add_breadcrumb 'Вакансии'
  end

  def show
    add_breadcrumb 'Вакансии', jobs_path
    add_breadcrumb @job.name
  end

  private

  def find_job
    @entity = @job = @company.jobs.find_by_translit! params[:id]
  end
end
