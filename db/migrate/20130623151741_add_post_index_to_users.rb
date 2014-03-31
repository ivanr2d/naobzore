class AddPostIndexToUsers < ActiveRecord::Migration
  def change
    add_column :users, :post_index, :integer
  end
end
