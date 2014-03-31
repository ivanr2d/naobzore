class AddCommentsCountToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :comments_count, :integer, :default => 0
  end
end
