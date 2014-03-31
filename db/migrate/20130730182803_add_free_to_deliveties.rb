class AddFreeToDeliveties < ActiveRecord::Migration
  def change
    add_column :deliveties, :free, :boolean, :default => true
  end
end
