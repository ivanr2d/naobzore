class CreateSupportUser < ActiveRecord::Migration
  def up
    User.create(:email => 'support@naobzore.ru', :f_name => 'support', :l_name => 'naobzore', :password => 'support', :password_confirmation => 'support', :lic => true)
  end

  def down
    User.find_by_email('support@naobzore.ru').try(:destroy)
  end
end
