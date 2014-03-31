class RenameFeedbacksCountToCommentsCountForCampaigns < ActiveRecord::Migration
  def up
    rename_column :campaigns, :feedbacks_count, :comments_count
  end

  def down
    rename_column :campaigns, :comments_count, :feedbacks_count
  end
end
