# encoding: utf-8

class CompanyPanel::ActsController < CompanyPanel::BaseController
  def index
    @acts = @company.acts.order("id DESC").paginate(:page => params[:page] || 1, :per_page => @per_page)
    Act.mark_as_read! @acts.to_a, :for => current_user
  end

  def show
    @act = @company.acts.find params[:id]
    @act.mark_as_read! :for => current_user
    @main_company = Company.main
    respond_to do |format|
      format.html {}
      format.pdf { render :pdf => @act.pdf_name, :layout => false, :template => 'company_panel/acts/show.html.erb' }
    end
  end

  private

  def set_widgets
    super.unshift(:balance)
  end
end
