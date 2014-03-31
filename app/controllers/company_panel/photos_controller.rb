# encoding: utf-8

class CompanyPanel::PhotosController < CompanyPanel::BaseController
  before_filter :find_photo, :only => [:update, :destroy]

  def index
    @entity_type = params[:entity_type] || 'Good'
    @photos = if %w(Good Service Campaign).include?(@entity_type)
      @company.photos.where(:entity_type => @entity_type)
    else
      @company.photos.where('entity_type NOT IN ("Good", "Service", "Campaign")')
    end.order('id desc').paginate(:page => params[:page] || 1, :per_page => @per_page)
  end

  def create
    @photo = Photo.new params[:photo]
    if @photo.save
      redirect_to company_panel_photos_path(:entity_type => params[:photo]['entity_type']), :notice => 'Фото загружено'
    else
      render :index
    end
  end

  def update
    if %w(Good Service Job Campaign).include?(entity_type = params[:photo]['entity_type']) && params[:article_name]
      params[:photo]['entity_id'] = entity_type.constantize.with_unpublished.find_by_article(params[:article_name].split('/').first).try(:id) or raise ActiveRecord::RecordNotFound
    end
    @photo.update_attributes(params[:photo])
    respond_to do |format|
      format.html { redirect_to company_panel_photos_path(:entity_type => @photo.entity_type), :notice => 'Фото изменено' }
      format.js { render :json => {:status => 'success'} }
    end
  end

  def destroy
    @photo.destroy
    redirect_to company_panel_photos_path(:entity_type => @photo.entity_type), :notice => 'Фото удалено'
  end

  def mass_destroy
    @company.photos.where(:id => params[:ids]).destroy_all
    flash[:notice] = 'Удалено'
    render :text => 'ok'
  end

  def entities
    if %w(Good Service Campaign).include?(params[:entity_type])
      @entities = params[:entity_type].constantize.where(:article => params[:q])
      @entities = params[:entity_type].constantize.where('name LIKE ?', "%#{params[:q]}%").limit(10)
    else
      @entities = News.where('name LIKE ?', "%#{params[:q]}%").limit(10)
    end
    render :json => @entities.map { |entity| entity.as_json.merge({ :entity_type => entity.class.to_s })}
  end

  private 

  def find_photo
    @photo = @company.photos.find params[:id]
  end
end
