class RenameTextToDescriptionInCampaigns < ActiveRecord::Migration
  def up
    rename_column :campaigns, :text, :description
  end

  def down
    rename_column :campaigns, :description, :text
  end
end
