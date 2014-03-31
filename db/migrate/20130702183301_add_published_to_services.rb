class AddPublishedToServices < ActiveRecord::Migration
  def change
    add_column :services, :published, :boolean, :default => true
  end
end
