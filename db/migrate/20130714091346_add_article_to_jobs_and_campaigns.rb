class AddArticleToJobsAndCampaigns < ActiveRecord::Migration
  def change
    add_column :jobs, :article, :integer
    add_column :campaigns, :article, :integer
  end
end
