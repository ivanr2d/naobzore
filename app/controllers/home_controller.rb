class HomeController < ApplicationController
  caches_action :index, :expires_in => 5.minutes if Rails.env.production?

  def index
    
    @tutorials = Tutorial.all
    
    #comp_visits = Visits.where("")
    
    @new_companies = Company.limit(10)
    @pop_companies = Company.order("views DESC").limit(10)
    
    @pop_goods = Good.order("views DESC").limit(20)
    @new_goods = Good.limit(10)
    @special_goods = Good.where("is_spec = 1").limit(20)
    
    @active_users = User.order("mark DESC").limit(20)
    
   end
end
