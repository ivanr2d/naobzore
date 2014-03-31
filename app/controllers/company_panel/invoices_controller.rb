# encoding: utf-8

class CompanyPanel::InvoicesController < CompanyPanel::BaseController
  before_filter :find_invoice, :only => [:show, :pay]
  before_filter :find_invoices, :only => [:index, :movement]
  before_filter :set_per_page, :only => [:index, :movement]

  def new
    @invoice = Invoice.new
  end

  def create
    if @company.update_attributes params[:company]
      @invoice = Invoice.new params[:invoice].merge(:company_id => @company.id, :entity_type => 'Fill')
      if @invoice.save
        return redirect_to company_panel_invoice_path(@invoice)
      end
    end
    render :new
  end

  def show
    @main_company = Company.main
    respond_to do |format|
      format.html {}
      format.pdf { render :pdf => @invoice.pdf_name, :layout => false, :template => 'company_panel/invoices/show.html.erb' }
    end
  end

  def index
  end

  def pay
    @invoice.update_attribute(:status, :complete) if @invoice.status == :process
    render :text => 'ok'
  end

  def movement
  end

  private

  def find_invoice
    @invoice = @company.invoices.find params[:id]
    @invoice.mark_as_read! :for => current_user
  end

  def find_invoices
    @invoices = @company.invoices.order("id DESC").paginate(:page => params[:page] || 1, :per_page => @per_page)
    Invoice.mark_as_read! @invoices.to_a, :for => current_user
  end

  def set_widgets
    super.unshift(:balance)
  end
    
end
