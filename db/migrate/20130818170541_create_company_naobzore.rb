# encoding: utf-8

class CreateCompanyNaobzore < ActiveRecord::Migration
  def up
    company = Company.create(
      :name => 'naobzore',
      :legal_name => 'ООО "Наобзоре"',
      :active => true,
      :inn => 2312312314,
      :kpp => 344343465,
      :settlement_account => 12343341234124123142,
      :bik => 123456789,
      :bank_cor_account => 12312312312211121212,
      :city => 'Оренбург',
      :bank_name => 'Сбербанк',
      :site_address => 'http://naobzore.ru',
      :user_id => 0,
      :category_id => 0
    )
    Site.create(
      :company_id => company.id,
      :title => 'Naobzore',
      :subdomen => 'main'
    )
  end

  def down
    Company.find_by_name('naobzore').try(:destroy)
  end
end
