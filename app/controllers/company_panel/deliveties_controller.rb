# encoding: utf-8

class CompanyPanel::DelivetiesController < CompanyPanel::BaseController
  before_filter { @h1 = 'Доставка' }
  before_filter :find_delivety, :only => [:edit, :update, :destroy]
  before_filter :prepare_params, :only => [:create, :update]

  def index
    @deliveties = @company.deliveties 
  end

  def new
    @delivety = Delivety.new
  end

  def create
    params[:delivety]['company_id'] = @company.id
    @delivety = Delivety.new params[:delivety]
    if @delivety.save
      redirect_to company_panel_deliveties_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @delivety.update_attributes params[:delivety]
      redirect_to company_panel_deliveties_path
    else
      render :edit
    end
  end

  def destroy
    @delivety.destroy
    redirect_to company_panel_deliveties_path
  end

  private

  def find_delivety
    @delivety = Delivety.find params[:id]
  end

  def prepare_params
    params[:delivety]['period'] = "#{params[:from_hour]}:#{params[:from_minute]}-#{params[:to_hour]}:#{params[:to_minute]}"
    params[:delivety]['cost'] = nil if params[:delivety]['free'].to_i == 1
  end
end
