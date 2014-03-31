class AddNotificationsToGoodsServicesJobs < ActiveRecord::Migration
  def change
    add_column :goods, :notifications, :string
    add_column :services, :notifications, :string
    add_column :jobs, :notifications, :string
  end
end
