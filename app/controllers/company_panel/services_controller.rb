# encoding: utf-8

class CompanyPanel::ServicesController < CompanyPanel::EntitiesController
  def initialize
    super
    @entity_type = 'Service'
  end

  def new
    super
    @h1 = 'Добавление услуги'
    @items = Service.where(:company_id => current_user.company.id)
  end

  def edit
    super
    @h1 = 'Редактирование услуги'
  end

end
