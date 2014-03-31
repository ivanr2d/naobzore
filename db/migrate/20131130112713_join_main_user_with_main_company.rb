class JoinMainUserWithMainCompany < ActiveRecord::Migration
  def up
    Company.main.update_attribute(:user_id, User.first.id)
  end

  def down
  end
end
