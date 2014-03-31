class AddColumnsGroupCampaignToServices < ActiveRecord::Migration
  def up
    add_column :services, :campaign, :integer
    add_column :services, :group, :integer
  end
  
  def down
    remove_column :services, :campaign
    remove_column :services, :group
  end
end
