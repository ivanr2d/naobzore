# encoding: utf-8

class CompanyPanel::MenusController < CompanyPanel::BaseController
  def index
    @menus = Menu.joins('left join companies_menus on menus.id = companies_menus.menu_id').order('companies_menus.pos, menus.name')
  end

  def set_order
    current_user.account.companies_menus = params[:ids].split(',').each_with_index.map { |id, pos| CompaniesMenu.new(:menu_id => id, :pos => pos) }
    CompaniesMenu.where(:company_id => nil).delete_all

    render :text => 'ok'
  end

end
