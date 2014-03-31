# encoding: utf-8

class CompanyPanel::BannersController < CompanyPanel::BaseController
  def new
    @banner = Banner.new
  end

  def set_widgets
    @widgets = [:menu, :support_service]
    @menu_title = current_user.company.human_balance 
  end

  def create
    @weeks = JSON.parse(params[:weeks])
    sum = @weeks.values.flatten.compact.count * Banner.week_price

    success = true
    Banner.transaction do
      @weeks.each do |type, weeks|
        weeks.each do |week|
          @banner = Banner.new(params[:banner].merge(:banner_type => type, :week => week, :company_id => @company.id))
          success = false and break(2) unless @banner.save
        end
      end
    end
    
    if success
      unless (invoice = @company.invoices.build(:sum => sum, :entity_type => 'Banner', :status => :complete)).save
        return redirect_to :back, :notice => invoice.errors.full_messages.join('<br />')
      end
      redirect_to new_company_panel_banner_path
    else
      render :new
    end
  end
end
