class CompanyPanel::CompaniesPackagesController < CompanyPanel::BaseController
  def create
    @package = Package.find params[:companies_package]['package_id']
    params[:companies_package]['start_at'] = Time.now
    months = params[:companies_package]['end_at'].to_i.months
    months = 3.months if months <= 0
    params[:companies_package]['end_at'] = Time.now + months
    params[:companies_package]['company_id'] = current_user.account.id
    @companies_package = CompaniesPackage.new(params[:companies_package])
    @res = @companies_package.save
  end

  def set_auto
    @companies_package = CompaniesPackage.find params[:id]
    @companies_package.update_attribute(:auto, params[:auto])
    @package = @companies_package.package
  end
end
