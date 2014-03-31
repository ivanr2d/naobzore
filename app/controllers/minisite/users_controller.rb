class Minisite::UsersController < Minisite::BaseController
  def subscribe
    [:lk, :email, :sms].each do |field|
      current_user.send("subscribe_#{field}=", !!params[field])
    end
    current_user.save
    render :text => 'ok'
  end
end
