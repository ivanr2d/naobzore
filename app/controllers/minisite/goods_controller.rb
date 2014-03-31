# encoding: utf-8

class Minisite::GoodsController < Minisite::EntitiesController
  def index
    super
    add_breadcrumb 'Товары'
  end
  
  def show
    super
    add_breadcrumb 'Товары', goods_path
    add_breadcrumb @entity.name
  end
  
  private

  def set_entity_type
    @entity_type = 'Good'
  end
end
