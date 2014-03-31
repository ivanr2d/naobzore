# encoding: utf-8

class CreateCities < ActiveRecord::Migration
  def up
    create_table :cities do |t|
      t.string :name
    end
    ActiveRecord::Base.connection.execute("INSERT INTO cities (name) VALUES ('Абдулино'),('Бугуруслан'),('Бузулук'),('Гай'),('Кувандык'),('Медногорск'),('Новотроицк'),('Оренбург'),('Орск'),('Соль-Илецк'),('Сорочинск'),('Ясный')")
  end

  def down
    drop_table :cities
  end
end
