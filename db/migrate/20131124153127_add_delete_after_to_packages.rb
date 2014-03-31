class AddDeleteAfterToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :delete_after, :date
  end
end
