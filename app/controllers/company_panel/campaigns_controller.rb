# encoding: utf-8

class CompanyPanel::CampaignsController < CompanyPanel::EntitiesController
  def initialize
    super
    @entity_type = 'Campaign'
  end

  def create
    super
  end

  def update
    %w(start_at end_at).each do |field|
      params[:entity][field] = DateTime.parse(params[:entity][field]) if params[:entity][field]
    end
    super
  end

  def new
    @entity = @entity_type.constantize.new(:company_id => @company.id, :end_at => Time.now + 1.month)
    @service = Good.limit(10)
    @service += Service.limit(10)
    @h1 = 'Добавление акции/скидки'
  end

  def edit
    super
    @h1 = 'Редактирование акции/скидки'
  end

  def entities
    entity_types = %w(Good Service)
    @entities = entity_types.map { |entity_type| entity_type.constantize.where(:article => params[:q]) }.flatten
    @entities = entity_types.map { |entity_type| entity_type.constantize.where('name LIKE ?', "%#{params[:q]}%").limit(10) }.flatten if @entities.empty?
    render :json => @entities.map { |entity| entity.as_json.merge({ :entity_type => entity.class.to_s })}
  end
end
