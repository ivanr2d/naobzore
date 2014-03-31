# encoding: utf-8

class Minisite::ServicesController < Minisite::EntitiesController
  def index
    super
    add_breadcrumb 'Услуги'
  end
  
  def show
    super
    add_breadcrumb 'Услуги', services_path
    add_breadcrumb @entity.name
  end
  
  private

  def set_entity_type
    @entity_type = 'Service'
  end
end
