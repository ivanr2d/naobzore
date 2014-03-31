# encoding: utf-8

class Minisite::HomeController < Minisite::BaseController
  def index
    @entities = (@company.goods.for_user(try(:current_user)) + @company.services.for_user(try(:current_user))).sample(8)
    @bottom_entities_title, @bottom_entities = if (@campaigns = @company.campaigns.for_user(try(:current_user)).order('start_at DESC').limit(4)).any?
      ['Акции', @campaigns]
    elsif (@jobs = @company.jobs.for_user(try(:current_user)).order('salary_from DESC').limit(4)).any?
      ['Вакансии', @jobs]
    elsif (@news = @company.news.for_user(try(:current_user)).order('id DESC').limit(4)).any?
      ['Новости', @news]
    end
  end

  def about
    add_breadcrumb 'О компании'
  end
  
  def contacts
    add_breadcrumb 'Контакты'
  end

  def search
    add_breadcrumb 'Поиск'
    results = []
    [ :goods, :services, :jobs, :campaigns, :news, :feedbacks ].each do |collection|
      instance_variable_set("@#{collection}", collection.to_s.classify.constantize.where("name LIKE ?", "%#{params[:q]}%"))
      instance_variable_set("@#{collection}", instance_variable_get("@#{collection}").where('maker = ?', params[:maker])) if [:goods, :services].include?(collection) && params[:maker].present?
      results << instance_variable_set("@#{collection}", instance_variable_get("@#{collection}").order("#{params[:order] && collection.to_s.classify.constantize.new.attributes.has_key?(params[:order]) ? params[:order] : 'id'} desc").paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 20))
    end
    render 'empty_search' if results.flatten.empty?
  end
end
