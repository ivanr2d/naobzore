class CreateUserComplaint < ActiveRecord::Migration
  def up
    User.create(:email => 'complaint@naobzore.ru', :f_name => 'complaint', :l_name => 'naobzore', :password => 'complaint', :password_confirmation => 'complaint', :lic => true)
  end

  def down
    User.complaint.try(:destroy)
  end
end
