class RenameGroupToFolderIdInGoodsAndServices < ActiveRecord::Migration
  def up
    rename_column :goods, :group, :folder_id
    rename_column :services, :group, :folder_id
  end

  def down
    rename_column :goods, :folder_id, :group
    rename_column :services, :folder_id, :group
  end
end
