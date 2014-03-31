class Minisite::CommentsController < Minisite::BaseController
  def index
    @entity = case
      when params[:job_id] then Job.find params[:job_id]
      when params[:news_id] then News.find params[:news_id]
      when params[:campaign_id] then Campaign.find params[:campaign_id]
    end
    @comments = @entity.comments
  end

  def create
    @comment = Comment.create(params[:comment])
    @comments = @comment.entity.comments.last(Comment::LAST_COUNT)
  end
end
