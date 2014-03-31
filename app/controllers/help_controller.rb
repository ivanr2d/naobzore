# coding: utf-8

class HelpController < ApplicationController
  layout "layouts/other"
  
  def index
    
    where = {
      :category => (params[:category]) ? "category_id = #{Category.find_by_alias(params[:category]).id}" : ""
    }
    
    @helps = Help.where(where[:category]).paginate(:page => params[:page], :per_page => 10)
    
  end

  def show
    @help = Help.find_by_alias(params[:alias])
    if !@help
      redirect_to root_path
    end
  end

end