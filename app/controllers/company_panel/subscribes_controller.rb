# encoding: utf-8

class CompanyPanel::SubscribesController < CompanyPanel::BaseController
  def index
    if category = current_user.account.category
      @subscribes = category.subscribes.paginate(:page => params[:page] || 1, :per_page => @per_page)
    else
      @subscribes = []
    end
  end

  def destroy
    @subscribe = Subscribe.find params[:id]
    @subscribe.destroy
    redirect_to company_panel_subscribes_path, :notice => 'Подписка удалена'
  end
end
