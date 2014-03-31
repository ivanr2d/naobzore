# encoding: utf-8

class CompanyPanel::JobsController < CompanyPanel::EntitiesController
  def initialize
    super
    @entity_type = 'Job'
  end

  def new
    super
    @h1 = 'Добавление вакансии'
    @jobs = Job.where(:company_id => current_user.company.id)
  end

  def edit
    super
    @h1 = 'Редактирование вакансии'
  end
end
