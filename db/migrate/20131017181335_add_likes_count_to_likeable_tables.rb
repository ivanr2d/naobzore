class AddLikesCountToLikeableTables < ActiveRecord::Migration
  def change
    [:goods, :services, :jobs, :campaigns, :news].each do |entity_table|
      add_column entity_table, :likes_count, :integer, :default => 0
    end
  end
end
