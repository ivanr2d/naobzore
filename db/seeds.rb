# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Settings.create ([
    { :id => 1,  :key => 'Left block', :value => 'lef block content', :title => '' },
    { :id => 2,  :key => 'Right block', :value => 'right block content', :title => '' },
    { :id => 3,  :key => 'delivery', :value => '0', :title => 'Доставка' }
])

Page.create ([
    { :id => 1, :title => 'Page 1' },
    { :id => 2, :title => 'Page 2' },
    { :id => 3, :title => 'Page 3' },
    { :id => 4, :title => 'Page 4' },
    { :id => 5, :title => 'Page 5' },
    { :id => 6, :title => 'Page 6' },
    { :id => 7, :title => 'Page 7' },
    { :id => 8, :title => 'Page 8' },
])

user = User.create(email: 'admin@test.ru', password: '1q2w3e4r', password_confirmation: '1q2w3e4r', lic: 1, account_type: 'admin')
user.active = 1
user.confirmation_token = ''
user.confirmed_at = Time.current.to_s(:db)
user.save
user.account = Company.create(
    name: 'ООО "Павел и Игорь"',
    category: Category.create(title: 'Разработка ПО', alias: 'software-development')
)