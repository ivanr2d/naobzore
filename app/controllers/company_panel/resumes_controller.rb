# encoding: utf-8

class CompanyPanel::ResumesController < CompanyPanel::BaseController
  before_filter :find_resume, :only => [:show, :destroy]

	def index
		@resumes = Resume.order('id desc').paginate(:page => params[:page] || 1, :per_page => @per_page)
	end

  def show
  end

  def destroy
    @resume.destroy
    redirect_to company_panel_resumes_path, :notice => 'Резюме удалено'
  end

  def search
    @resumes = Resume.where('name LIKE ?', "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @resumes }
    end
  end

  private

  def find_resume
    @resume = Resume.find(params[:id])
  end
end
