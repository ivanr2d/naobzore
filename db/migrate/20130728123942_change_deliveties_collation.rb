class ChangeDelivetiesCollation < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("ALTER TABLE deliveties CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci")
  end

  def down
  end
end
