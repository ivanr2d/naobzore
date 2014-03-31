class SocialController < ApplicationController
  def export
    redirect_to params[:entity_type].constantize.find(params[:entity_id]).social_share(params[:social], request.referer)
  end
end
