class FavoritesController < ApplicationController
  
  #-!- ДЛЯ ИГНОРА ИСКЛЮЧАЕМ ID В ЗАПРОСАХ НА СУЩНОСТИ
  def plus
    
    @result = 0 #0 - Ошибка, 1 - Уже есть, 2 - добавлено
    
    entity_type = (params[:type]) ? params[:type] : nil
    entity_id   = (params[:id]) ? params[:id] : nil
    status      = (params[:status]) ? params[:status] : 0
    
    if user_signed_in? && entity_type && entity_id
      
      favorite = Favorite.where(:user_id => current_user.id, :entity_type => entity_type, :entity_id => entity_id)
      
      if favorite.count < 1
        favorite = Favorite.new(
          :user_id => current_user.id, 
          :entity_type => entity_type, 
          :entity_id => entity_id,
          :status => status
        ).save()
        
        @result = 2
      else
        @result = 1
      end
      
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
end
