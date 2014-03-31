class AddParentIdAndNumberToFolders < ActiveRecord::Migration
  def change
    add_column :folders, :parent_id, :integer
    add_column :folders, :number, :integer
  end
end
