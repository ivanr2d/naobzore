# encoding: utf-8

class Minisite::ResumesController < Minisite::BaseController
  before_filter :authenticate_user!

  def resume_send
    @companies_resume = CompaniesResume.new(:job_id => params[:job_id], :resume_id => params[:id], :company_id => Job.find(params[:job_id]).company_id)
    if @companies_resume.save
      render :json => { :success => true }
    else
      render :json => { :error => @companies_resume.errors.full_messages }
    end
  end
end
