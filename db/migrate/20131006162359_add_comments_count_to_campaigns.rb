class AddCommentsCountToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :comments_count, :integer, :default => 0
  end
end
