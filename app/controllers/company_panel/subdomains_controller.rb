# encoding: utf-8

class CompanyPanel::SubdomainsController < CompanyPanel::BaseController
  before_filter { @company = current_user.account }

  def index
    @subdomains = @company.subdomains
    @site = @company.site
  end

  def mass_save
    begin
      @company.subdomains = params[:subdomain].delete_if { |s| s.blank? }.map { |s| Subdomain.new(:name => s) }
    rescue
    end
    redirect_to company_panel_subdomains_path
  end

end
