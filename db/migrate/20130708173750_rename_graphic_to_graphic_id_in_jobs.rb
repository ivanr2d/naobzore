class RenameGraphicToGraphicIdInJobs < ActiveRecord::Migration
  def up
    rename_column :jobs, :graphic, :graphic_id
  end

  def down
    rename_column :jobs, :graphic, :graphic_id
  end
end
