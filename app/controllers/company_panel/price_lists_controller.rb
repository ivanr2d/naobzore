# encoding: utf-8

class CompanyPanel::PriceListsController < CompanyPanel::BaseController
  def new
    @price_list = PriceList.new
  end

  def create
    params[:price_list]['refreshed_fields'] = (params[:price_list]['refreshed_fields'] || []).join(',')
    @price_list = PriceList.new params[:price_list]
    if @price_list.save
      redirect_to company_panel_price_entities_path
    else
      render :new
    end
  end
end
