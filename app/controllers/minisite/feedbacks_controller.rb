class Minisite::FeedbacksController < Minisite::BaseController
  before_filter :find_feedback, :only => [:like, :ignore, :favorite]
  include Likes

  private

  def find_feedback
    @entity = @feedback = Feedback.find params[:id]
  end
end
