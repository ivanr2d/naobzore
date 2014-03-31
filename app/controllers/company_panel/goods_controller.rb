# encoding: utf-8

class CompanyPanel::GoodsController < CompanyPanel::EntitiesController
  def initialize
    super
    @entity_type = 'Good'
  end

  def new
    super
    @h1 = 'Добавление товара'
    @items = Good.where(:company_id => current_user.company.id)
  end

  def edit
    super
    @h1 = 'Редактирование товара'
  end
end
