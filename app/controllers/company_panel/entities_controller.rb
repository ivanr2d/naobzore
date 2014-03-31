# encoding: utf-8

class CompanyPanel::EntitiesController < CompanyPanel::BaseController
  before_filter :find_entity, :only => [:edit, :update, :mass_set_photos, :load_image]
  before_filter :find_entities, :only => [:mass_publish, :mass_unpublish, :mass_destroy]
  before_filter :prepare_notifications, :only => [:create, :update]
  # XXX
  around_filter :save_photos, :only => [:create, :update]

  def index
    @entities = current_user.account.send(@entity_type.tableize.to_sym).with_unpublished.order(:name).paginate(:page => params[:page] || 1, :per_page => @per_page)
  end

  def new
    @entity = @entity_type.constantize.new(:company_id => @company.id)#
    dimension = Dimensionw.select(:name)
    @dimension = []
    dimension.select {|item| @dimension << item.name}
  end

  def create
    respond_to do |format|
      @entity = @entity_type.constantize.new params[:entity]
      if @entity.save
        Characteristic.create(params[:characteristics].map { |c| {:key => c['key'], :value => c['value'], :entity_id => @entity.id, :entity_type => @entity.class.to_s} }) if params[:characteristics]
        format.html { redirect_to send("company_panel_#{@entity_type.tableize}_path".to_sym), :notice => 'Добавлено' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      params[:characteristics] ||= [] if @entity.respond_to?(:characteristics) && request.format.to_sym == :html
      if params[:characteristics]
        @entity.characteristics = if params[:characteristics].is_a?(Hash)
          params[:characteristics].map { |key, value| Characteristic.new(:key => key, :value => value) unless key.blank? }.compact
        else
          params[:characteristics].map { |c| Characteristic.new(c) unless c['key'].blank? }.compact
        end
      end
      if params[:phone_number]
        phone = []
        params[:phone_number].each_with_index do |phone_number, index|
          unless phone_number.blank?
            phone << "+7(#{params[:phone_code][index].gsub(/\D/, '')})#{phone_number}" + (params[:phone_dob][index].blank? ? '' : "(#{params[:phone_dob][index]})")
          end
        end
        params[:entity]['contact_phone'] = phone.join(';')
      end
      if params[:fax_number]
        fax = []
        params[:fax_number].each_with_index do |fax_number, index|
          unless fax_number.blank?
            fax << "+7(#{params[:fax_code][index].gsub(/\D/, '')})#{fax_number}"
          end
        end
        params[:entity]['contact_fax'] = fax.join(';')
      end
      if @entity_type.constantize.send(:with_exclusive_scope) { @entity.update_attributes params[:entity] }
        format.html { redirect_to send("company_panel_#{@entity_type.tableize}_path".to_sym), :notice => 'Сохранено' }
        format.any(:js, :json) { render :json => {:status => 'success', :message => 'Сохранено', :entity => @entity.to_json(:methods => :main_photo)} }
      else
        format.html { render :edit }
        format.any(:js, :json) { render :json => {:status => 'error', :message => @entity.errors.full_messages.join('<br />')} }
      end
    end
  end

  def mass_publish
    @entities.each { |entity| entity.update_attribute(:published, true) }
    flash[:notice] = @entities.reload.with_unpublished.where(:published => false).any? ? 'Не всё опубликовано' : 'Опубликовано'
    render :text => 'ok'
  end

  def mass_unpublish
    @entities.update_all(:published => false)
    flash[:notice] = 'Услуги сняты с публикации'
    render :text => 'ok'
  end

  def mass_destroy
    @entities.update_all(:deleted_at => Time.now)
    flash[:notice] = 'Удалено'
    render :text => 'ok'
  end

  def search
    respond_to do |format|
      format.json { render :json => current_user.account.send(@entity_type.tableize.to_sym).where("name like ?", "%#{params[:term]}%").with_unpublished.order(:name).map(&:article_name) }
    end
  end

  def mass_set_photos
    @entity.photos = params[:photo_ids].to_s.split(',').map { |photo_id| Photo.find_by_id(photo_id) }.compact
    render :json => {:status => 'success', :message => 'Сохранено', :entity => @entity.to_json(:methods => :main_photo)}
  end

  def load_image
    render :partial => 'company_panel/shared/form_image_popup'
  end

  private 

  def find_entity
    @entity = @entity_type.constantize.with_unpublished.find_by_translit! params[:id]
  end

  def find_entities
    @entities = @entity_type.constantize.with_unpublished.where(:company_id => current_user.account.id, :id => params[:ids])
  end

  def set_widgets
    @widgets = [:user_status, :adding] + super
    @menu_links = [
      {:href => company_panel_root_path, :name => 'Панель управления кабинетом'},
      {:href => new_company_panel_price_list_path, :name => 'Импорт прайс-листа'},
      {:href => company_panel_photos_path, :name => 'Каталог фото'}
    ]
  end

  def prepare_notifications
    params[:entity] ||= {}
    # TODO rewrite
    return if params[:entity]['notifications'].is_a? String
    params[:entity]['notifications'] = (params[:entity]['notifications'] || []).join(',')
  end

  # XXX
  def save_photos
    main_photo_param = params[:entity].delete(:main_photo)
    yield
    @entity.photos = params[:photos_ids].to_a.map { |id| Photo.find(id) }
    @entity.main_photo = main_photo_param if main_photo_param
  end
end
