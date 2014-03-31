class AddPublishedToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :published, :boolean, :default => true
  end
end
