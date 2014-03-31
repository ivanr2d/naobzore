class AddFeedbacksCountToServices < ActiveRecord::Migration
  def change
    add_column :services, :feedbacks_count, :integer, :default => 0
    rename_column :goods, :comments_count, :feedbacks_count
    rename_column :campaigns, :comments_count, :feedbacks_count
  end
end
