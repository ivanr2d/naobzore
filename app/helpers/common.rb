# coding: utf-8

#Общий модуль
module Common
  
  #Существующие типы
  #
  def self.types
    return [['Товары', 'Good'], ['Услуги', 'Service'], ['Предприятия', 'Company'], ['Вакансии', 'Job'], ['Новости', 'News'], ['Акции', 'Campaign'], ['Отзывы', 'Feedback'], ['Объявления', 'Ad']]
  end
  
  #Получение типа
  def self.get_type(type)
    result = nil
    Common.types.each do |value, key|
      if type == key
        result = value
      end
    end
    return result
  end
  
  #Существующие роли
  #
  def self.roles
    return [['Пользователь', 'user'], ['Предприятие', 'company'], ['Модератор', 'moder'], ['Администратор', 'admin']]
  end
  
  #Получение роли
  #
  def self.get_role(role)
    result = nil
    Common.roles.each do |value, key|
      if role == key
        result = value
      end
    end
    return result
  end

  
end
