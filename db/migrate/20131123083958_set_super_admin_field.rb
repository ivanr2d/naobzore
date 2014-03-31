class SetSuperAdminField < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("UPDATE users SET superadmin = 1 where account_type = 'admin'")
  end

  def down
    ActiveRecord::Base.connection.execute("UPDATE users SET superadmin = 0 WHERE id != 1")
  end
end
