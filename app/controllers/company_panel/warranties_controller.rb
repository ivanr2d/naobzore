# encoding: utf-8

class CompanyPanel::WarrantiesController < CompanyPanel::BaseController
  before_filter { @h1 = 'Гарантия' }
  before_filter :find_warranty, :only => [:edit, :update, :destroy]

  def index
    @warranties = @company.warranties 
  end

  def new
    @warranty = Warranty.new
  end

  def create
    params[:warranty]['company_id'] = @company.id
    @warranty = Warranty.new params[:warranty]
    if @warranty.save
      redirect_to company_panel_warranties_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @warranty.update_attributes params[:warranty]
      redirect_to company_panel_warranties_path
    else
      render :edit
    end
  end

  def destroy
    @warranty.destroy
    redirect_to company_panel_warranties_path
  end

  private

  def find_warranty
    @warranty = @company.warranties.find params[:id]
  end
end
