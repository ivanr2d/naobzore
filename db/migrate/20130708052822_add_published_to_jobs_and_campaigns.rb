class AddPublishedToJobsAndCampaigns < ActiveRecord::Migration
  def change
    add_column :jobs, :published, :boolean, :default => true
    add_column :campaigns, :published, :boolean, :default => true
  end
end
