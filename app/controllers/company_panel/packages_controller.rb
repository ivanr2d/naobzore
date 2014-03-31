class CompanyPanel::PackagesController < CompanyPanel::BaseController
  %w(placing communication).each do |method|
    define_method(method.to_sym) do
      @packages = Package.send(method.to_sym).for_company(@company).order(:price)
    end
  end

  def set_widgets
    @widgets = [:menu, :support_service ]
    @menu_title = current_user.company.human_balance 
  end
 
end
