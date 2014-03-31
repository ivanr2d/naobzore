# coding: utf-8

class CompanyPanel::BaseController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :find_company
  before_filter :set_widgets
  before_filter :set_per_page, :only => [:index]
  
  #Опции
  layout "company_panel/layouts/company_panel"

  def find_company
    @company = current_user.account
  end

  def set_widgets
    @widgets = [:menu, :support_service]
  end

  def set_per_page
    @per_page = if params[:per_page].to_i > 0
      cookies[:per_page] = params[:per_page].to_i
    elsif cookies[:per_page].to_i > 0
      cookies[:per_page].to_i
    else
      CONFIG[:per_page]
    end
  end
end
