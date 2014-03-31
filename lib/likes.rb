module Likes
  def like
    if (like = @entity.likes.find_or_initialize_by_user_id(current_user.id)).new_record?
      like.save
      render :text => @entity.likes_count + 1
    else
      like.destroy
      render :text => @entity.likes_count - 1
    end
  end

  def ignore
    field = "ignored_#{@entity.class.to_s.tableize}".to_sym
    value = current_user.send(field).to_s.split(',').push(@entity.id).uniq.join(',')
    current_user.update_attribute(field, value)
    render :text => value
  end

  def favorite
    if (favorite = @entity.favorites.find_or_initialize_by_user_id(current_user.id)).new_record?
      favorite.save
    else
      favorite.destroy
    end
    render :text => 'ok'
  end
end
