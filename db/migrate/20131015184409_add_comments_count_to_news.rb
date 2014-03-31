class AddCommentsCountToNews < ActiveRecord::Migration
  def change
    add_column :news, :comments_count, :integer, :default => 0
  end
end
