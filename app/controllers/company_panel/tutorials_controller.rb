class CompanyPanel::TutorialsController < CompanyPanel::BaseController
  def index
    @tutorials = Tutorial.all
  end
end
