class AddStartAtEndAtNotificationsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :start_at, :datetime
    add_column :campaigns, :end_at, :datetime
    add_column :campaigns, :notifications, :string
  end
end
