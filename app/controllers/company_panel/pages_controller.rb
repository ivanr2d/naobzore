# encoding: utf-8

class CompanyPanel::PagesController < CompanyPanel::BaseController
  def show
    @page = Page.find_by_link params[:link]
  end

  def set_widgets
    @widgets = [:menu, :support_service]
    @menu_title = current_user.company.human_balance 
  end
end
