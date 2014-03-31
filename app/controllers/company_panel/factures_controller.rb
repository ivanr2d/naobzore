# encoding: utf-8

class CompanyPanel::FacturesController < CompanyPanel::BaseController
  def index
    @factures = @company.factures.order("id DESC").paginate(:page => params[:page] || 1, :per_page => @per_page)
    Facture.mark_as_read! @factures.to_a, :for => current_user
  end

  def show
    @facture = @company.factures.find params[:id]
    @facture.mark_as_read! :for => current_user
    @main_company = Company.main
    respond_to do |format|
      format.html {}
      format.pdf { render :pdf => @facture.pdf_name, :layout => false, :template => 'company_panel/factures/show.html.erb' }
    end
  end
  
  private

  def set_widgets
    super.unshift(:balance)
  end
end
