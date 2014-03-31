class AddSexToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sex, :integer, :limit => 1
  end
end
