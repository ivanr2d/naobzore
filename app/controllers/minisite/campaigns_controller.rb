# encoding: utf-8

class Minisite::CampaignsController < Minisite::BaseController
  before_filter :find_campaign, :only => [:show, :campaign_send, :like, :ignore, :favorite]
  before_filter :add_meta
  include Likes

  def index
    @campaigns = @company.campaigns
    @campaigns = @campaigns.for_user(current_user) if user_signed_in?
    @campaigns = @campaigns.order(case params[:order]
      when 'comments_count' then 'comments_count desc'
      when 'views' then 'views desc'
      else 'id desc'
    end).paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 20)
    add_breadcrumb 'Акции'
  end

  def show
    add_breadcrumb 'Акции', campaigns_path
    add_breadcrumb @campaign.name
  end

  def campaign_send
    unless !params[:campaign] || params[:campaign]['email'].blank?
      CampaignsMailer.campaign_send(@campaign, params[:campaign]['email']).deliver
      render :text => 'ok'
    else
      render :text => 'error'
    end
  end

  private

  def find_campaign
    @entity = @campaign = @company.campaigns.find_by_translit! params[:id]
  end
end
