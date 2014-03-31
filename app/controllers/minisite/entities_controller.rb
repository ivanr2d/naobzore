class Minisite::EntitiesController < Minisite::BaseController
  before_filter :authenticate_user!, :only => [:like, :ignore, :favorite]
  before_filter :set_entity_type
  before_filter :find_entity, :only => [:show, :like, :ignore, :favorite]
  before_filter :add_meta
  include Likes

  def index
    @entities = @company.send(@entity_type.tableize.to_sym)
    @min_price = @entities.map(&:price).compact.min
    @max_price = @entities.map(&:price).compact.max
    @entities = @entities.where('price >= ? AND price <= ?', params[:min_price].to_i, params[:max_price].to_i) if params[:min_price] && params[:max_price]
    @entities = @entities.with_campaign if params[:with_campaign] && @entities.respond_to?(:with_campaign)
    @entities = @entities.for_user(current_user) if user_signed_in?
    @entities = @entities.where(:category_id => params[:category_id]) if params[:category_id].present?
    @entities = @entities.order(case params[:order]
      when 'feedbacks_count' then 'feedbacks_count desc'
      when 'views' then 'views desc'
      else 'created_at desc'
    end)
    @entities = @entities.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 20)
  end

  def show
  end

  protected
  
  def set_entity_type
    raise NotImplementedError
  end

  def find_entity
    @entity = @entity_type.constantize.find_by_translit! params[:id]
  end
end
