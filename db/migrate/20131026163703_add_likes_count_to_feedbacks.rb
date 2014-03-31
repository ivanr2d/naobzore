class AddLikesCountToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :likes_count, :integer, :default => 0
  end
end
