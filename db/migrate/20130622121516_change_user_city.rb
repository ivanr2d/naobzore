class ChangeUserCity < ActiveRecord::Migration
  def up
    add_column :users, :city_id, :integer
    remove_column :users, :city
  end

  def down
    add_column :users, :city, :string, :limit => 64
    remove_column :users, :city_id
  end
end
