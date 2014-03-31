# encoding: utf-8

class CompanyPanel::EmailsController < CompanyPanel::BaseController
  def index
    @emails = Email.order('id desc').paginate(:page => params[:page] || 1, :per_page => @per_page)
  end
end
