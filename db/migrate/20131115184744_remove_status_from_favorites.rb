class RemoveStatusFromFavorites < ActiveRecord::Migration
  def up
    remove_column :favorites, :status
  end

  def down
    add_column :favorites, :status, :integer, :null => false
  end
end
