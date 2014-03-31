class RenameColumnCampaignToGoodsServices < ActiveRecord::Migration
  def up
    rename_column :goods, :campaign, :campaign_id
    rename_column :services, :campaign, :campaign_id
  end

  def down
    rename_column :goods, :campaign_id, :campaign
    rename_column :services, :campaign_id, :campaign
  end
end
