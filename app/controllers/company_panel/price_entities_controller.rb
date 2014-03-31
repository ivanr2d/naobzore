# encoding: utf-8

class CompanyPanel::PriceEntitiesController < CompanyPanel::EntitiesController
  def initialize
    super
    @entity_type = 'PriceEntity'
  end

  def index
    @price_list = current_user.account.price_lists.last
    @price_entities = @price_list.price_entities
    @price_entities = @price_entities.where(:category_id => Category.where(:cat_type => params[:cat_type]).pluck(:id)) if params[:cat_type]
    @price_entities = @price_entities.paginate(:page => params[:page] || 1, :per_page => @per_page)
    @h1 = 'Товары' if params[:cat_type] == 'Good'
    @h1 = 'Услуги' if params[:cat_type] == 'Service'
  end

  def update
    @entity = PriceEntity.find params[:id]
    if params[:characteristics]
      @entity.characteristics = if params[:characteristics].is_a?(Hash)
        params[:characteristics].map { |key, value| Characteristic.new(:key => key, :value => value) unless key.blank? }.compact
      else
        params[:characteristics].map { |c| Characteristic.new(c) unless c['key'].blank? }.compact
      end
    end
    params[:entity].each do |k,v|
      @entity.send("#{k}=", v)
    end
    @entity.save(:validate => false)
    respond_to do |format|
      format.any(:js, :json) { render :json => {:status => 'success', :message => 'Сохранено', :entity => @entity.to_json} }
      format.html { redirect_to company_panel_price_entities_path }
    end
  end
  
  def mass_destroy
    PriceEntity.where(:company_id => current_user.account.id, :id => params[:ids]).destroy_all
    flash[:notice] = 'Удалено'
    render :text => 'ok'
  end

  def export
    @price_list = PriceList.find(params[:id])
    @price_entities = @price_list.price_entities
    @price_entities = @price_entities.where(:category_id => Category.where(:cat_type => params[:cat_type]).pluck(:id)) unless params[:cat_type].blank?
    @price_entities = @price_entities.select { |e| e.valid? }
    if @price_list.export @price_entities
      redirect_to company_panel_price_entities_path, :notice => "Сохранено позиций: #{@price_entities.count}"
    else
      redirect_to company_panel_price_entities_path, :notice => @price_list.errors.full_messages.join('<br />')
    end
  end
end
