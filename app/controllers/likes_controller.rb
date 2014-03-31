class LikesController < ApplicationController
  
  def add
    
    @result = 0 #0 - Ошибка, 1 - удалено, 2 - добавлено
    
    entity_type = (params[:type]) ? params[:type] : nil
    entity_id   = (params[:id]) ? params[:id] : nil
    
    if user_signed_in? && entity_type && entity_id
      
      like = Like.where(:user_id => current_user.id, :entity_type => entity_type, :entity_id => entity_id)
      
      if like.count < 1
        like = Like.new(
          :user_id => current_user.id,
          :entity_type => entity_type,
          :entity_id => entity_id
        ).save()
        
        @result = 2
      else
        like.each do |l|
          l.delete
        end
        @result = 1
      end
      
    end
    
    response.headers['Content-type'] = "text/plain; charset=utf-8"
    render :text => @result.to_json
  end
  
end
