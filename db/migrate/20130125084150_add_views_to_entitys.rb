class AddViewsToEntitys < ActiveRecord::Migration
  def up
    add_column :goods, :views, :integer
    add_column :goods, :is_spec, :integer
    add_column :services, :views, :integer
    add_column :companies, :views, :integer
    add_column :campaigns, :views, :integer
    add_column :jobs, :views, :integer
    add_column :users, :bonuses, :integer
    add_column :users, :mark, :integer
    add_column :users, :main_photo, :string
  end
  
  def down
    remove_column :goods, :views
    remove_column :goods, :is_spec
    remove_column :services, :views
    remove_column :companies, :views
    remove_column :campaigns, :views
    remove_column :jobs, :views
    remove_column :users, :bonuses
    remove_column :users, :mark
    remove_column :users, :main_photo
  end
end
