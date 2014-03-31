# encoding: utf-8

class CompanyPanel::SitesController < CompanyPanel::BaseController
  before_filter :save_action
  before_filter :find_site
  before_filter :find_page, :only => [:stats, :webmaster, :sitemap]
  before_filter :handle_uploader_params, :only => :update


  def set_widgets
    @widgets = [:menu, :support_service]
    @menu_controller = 'company_panel/site_control/sites/'
  end

  def stats
  end

  def webmaster
  end

  def sitemap
     respond_to do |format|
        format.html
        format.xml
     end
  end
  
  def robots
  end

  def construct
    render :layout => 'company_panel/layouts/construct'
  end

  def update
    @company.update_attributes(params[:company]) if params[:company]
    success = @site.update_attributes(params[:site])
    
    respond_to do |format|
      format.html do
        if success || session['current_action'] == 'construct'
          #redirect_to :controller => session['current_controller'], :action => session['current_action'], :id => @site.id
          redirect_to @site.main_url(:construct_mode => true)
        else
          render session['current_action']
        end
      end
      format.json do
        if success
          render :json => { :success => true, :site => @site.to_json }
        else
          render :json => { :success => false, :site => @site.to_json, :errors => @site.errors.full_messages }
        end
      end
    end
  end

  def commit
    @site.commit
    redirect_to @site.main_url(:construct_mode => true)
  end



  private

  def save_action
    session['current_controller'] = params[:controller] if request.method == 'GET'
    session['current_action'] = params[:action] if request.method == 'GET'
  end

  def find_site
    @site = current_user.account.site
  end

  def find_page
    @page = Page.find_by_link!(params[:action])
  end

  def handle_uploader_params
    Site.uploader_fields.keys.each do |uploader_field|
      if params[:site][uploader_field].to_s.index('http') == 0
        params[:site]["remote_#{uploader_field}_url"] = params[:site].delete(uploader_field)
      end
    end
  end
end
