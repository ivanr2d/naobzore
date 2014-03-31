class CompanyPanel::FeedbacksController < CompanyPanel::BaseController
  def index
    @feedbacks = Feedback.order('id desc').paginate(:page => params[:page])
  end
end
