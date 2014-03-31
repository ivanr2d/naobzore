# encoding: utf-8

class CompanyPanel::HomeController < CompanyPanel::BaseController
  layout "company_panel/layouts/home"

  def index
    @widgets = [:balance, :view_statistics, :pay_services, :user_status, :mail_connection, :possibilities, :information, :adding, :support_service]
  end

  def save_widgets_order
    params[:ids].each_with_index { |id, pos| Widget.find(id).update_attribute(:pos, pos) }
    render :text => 'ok'
  end

  def mail
    @widgets = [:mail_connection]
    @h1 = 'Панель управления почта и связь'
  end

  def site_control
    @widgets = [:support_service, :minisite, :webmaster, :menu]
  end

  def set_widgets
    super
    @menu_controller = 'company_panel/site_control'
  end
end
