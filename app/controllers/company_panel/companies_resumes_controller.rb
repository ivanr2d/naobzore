# encoding: utf-8

class CompanyPanel::CompaniesResumesController < CompanyPanel::BaseController
  before_filter :find_companies_resume, :only => [:change_status, :destroy]
  before_filter :find_companies_resumes, :onlt => [:mass_reject, :mass_destroy]

  def index
    @companies_resumes = @company.companies_resumes.includes(:job, :resume).order('status asc, created_at desc')
    @companies_resumes = @companies_resumes.with_job_id if params[:with_job_id]
    @companies_resumes = @companies_resumes.where(:status => params[:status]) if params[:status]
    @companies_resumes = @companies_resumes.page(params[:page]).per_page(@per_page)
  end

  def change_status
    @message = Message.new(:from_id => current_user.id)
    if params[:companies_resume]['status'] == 'rejected'
      @message.text = "Уважаемый #{@companies_resume.resume.user.fio}, организация #{current_user.company.name} отказала вам в собеседовании"
      @message.text += " по вакансии #{@companies_resume.job.name}" if @companies_resume.job
    else
      @message.text = params[:message]['text']
    end
    if @success = @message.save
      @message.receivers << @companies_resume.resume.user
      @companies_resume.update_attribute(:status, params[:companies_resume]['status'])
    end
  end

  def destroy
    @companies_resume.destroy
    redirect_to company_panel_companies_resumes_path
  end

  def mass_reject
    @companies_resumes.update_all(:status => :rejected)
    redirect_to :back
  end

  def mass_destroy
    @companies_resumes.delete_all
    redirect_to :back
  end

  private

  def find_companies_resume
    @companies_resume = @company.companies_resumes.find params[:id]
  end

  def find_companies_resumes
    @companies_resumes = @company.companies_resumes.where(:id => params[:ids])
  end
end
