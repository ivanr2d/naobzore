# coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :base_construct
  I18n.locale = :ru
  
  prepend_before_filter :store_location

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.superadmin?
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource)
    previous_url || root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer || root_path
  end

  def after_confirmation_path_for(resource_name, resource)
    root_path
  end

# XXX убрать вообще этот код
def base_construct
  return true if params[:controller].match(/^(admin|company_panel)/)
@curent_controller = params[:controller]
@this_pages = Page.all

#----------------------------------------------------------------------------------
# Данные для блоков на главной
#----------------------------------------------------------------------------------
if @curent_controller == "home"
  @info_blocks = Settings.find([1,2])
end

@entities = {
    :goods => 'Товары',
    :services => 'Услуги',
    :jobs => 'Вакансии',
    :resume => 'Резюме',
    :companies => 'Предприятия',
    :news => 'Новости',
    :campaigns => 'Акции',
    :feedbacks => 'Отзывы'
  }
  
  #-----------------------------------------------------------------------------------
  # Получение категорий по текущему ТИПУ категорий
  # Также на странице может присутствовать 2 блока с категориями разного типа
  # 1 - Один блок с не явным контроллером
  # 2 - Два блока с явными контроллерами(goods,services)
  # 3 - Два блока с НЕ явными контроллерами
  #-----------------------------------------------------------------------------------
  @block_categories = 1
  if @curent_controller == 'goods'
    @this_categories = Category.where("cat_type = 'Good'")
  elsif @curent_controller == 'services'
    @this_categories = Category.where("cat_type = 'Service'")
  elsif @curent_controller == 'jobs' || @curent_controller == 'resume'
    @this_categories = Category.where("cat_type = 'Job'")
  elsif @curent_controller == 'news'
    @this_categories = Category.where("cat_type = 'News'")
  elsif @curent_controller == 'help'
    @this_categories = Category.where("cat_type = 'Help'")
  elsif @curent_controller == 'companies' || @curent_controller == 'feedbacks' || @curent_controller == 'campaigns'
    @this_categories = nil
    @this_categories_goods = Category.where("cat_type = 'Good'")
    @this_categories_services = Category.where("cat_type = 'Service'")
    @block_categories = 3
  else
    @this_categories = nil
    @this_categories_goods = Category.where("cat_type = 'Good'")
    @this_categories_services = Category.where("cat_type = 'Service'")
    @block_categories = 2
  end
  
  
  #--------------------------------------------------------------------------------
  #Формирование хлебных крошек (Ссылка на главную зашита намертво)
  #--------------------------------------------------------------------------------
  @parents_categories = Category.get_parents_aliases(params[:category])
  @breadcrumbs = []
  
  @entities.each do |controller, title|
    if "#{controller}" == "#{@curent_controller}"
      @breadcrumbs[0] = {
          :url => controller,
          :title => title
        }
        i = 1
        @parents_categories.each do |category|
          if(category != 0)
            @breadcrumbs[i] = {
              :url => "#{controller}" + "/#{category}",
              :title => Category.find_by_alias(category).title
            }
            i += 1
          end
        end
      end
    end
    
    #-----------------------------------------------------------------------------------
    #Получение баннеров в зависимости от текущего контроллера
    #-----------------------------------------------------------------------------------
    @this_banners = nil
    
    if @curent_controller == "home"
      @this_banners = Banner.where("banner_type = 'home'")
    elsif @curent_controller == 'goods'
      @this_banners = Banner.where("banner_type = 'Good'")
    elsif @curent_controller == 'services'
      @this_banners = Banner.where("banner_type = 'Service'")
    elsif @curent_controller == 'jobs'
      @this_banners = Banner.where("banner_type = 'Job'")
    elsif @curent_controller == 'companies'
      @this_banners = Banner.where("banner_type = 'Company'")
    elsif @curent_controller == 'news'
      @this_banners = Banner.where("banner_type = 'News'")
    elsif @curent_controller == 'campaigns'
      @this_banners = Banner.where("banner_type = 'Campaigns'")
    elsif @curent_controller == 'feedbacks'
      @this_banners = Banner.where("banner_type = 'Feedback'")
    end
  end

  def render_404
    render 'public/404.html', :status => :not_found, :layout => nil
  end

  protected

  def meta(a, b = nil)
    @meta ||= []
    if a.kind_of? Hash
      @meta << a
    else
      @meta << {:name => a, :content => b}
    end
  end

  def link(a, b = nil)
    @links ||= []
    if a.kind_of? Hash
      @links << a
    else
      @links << {:rel => a, :href => b}
    end
  end

  private

  def store_location
    if not devise_controller? and request.format and request.format.html? and request.get? and not request.xhr? and current_domain.present?
      session[:previous_url] = "http://" + current_domain + request.fullpath
    end
  end

  def previous_url
    session[:previous_url]
  end

  def current_domain
    subdomain = request.subdomains.join(".")
    domain = request.domain
    domain = subdomain + "." + domain if subdomain.present?
    domain
  end
end
