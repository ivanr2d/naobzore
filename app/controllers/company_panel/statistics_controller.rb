class CompanyPanel::StatisticsController < CompanyPanel::BaseController
	# TODO move 6 to config
  def index
    respond_to do |format|
			params[:entity_type] = 'Good' unless %w(Service Job Campaign).include?(params[:entity_type])
			format.html do		
				@statistics = Statistic.by params[:entity_type], :from => Time.now.to_i - 6.days, :company_id => current_user.account.id
			end
      format.json do
        render :json => Statistic.by(params[:entity_type], :company_id => current_user.account.id)
      end
    end
  end
end
