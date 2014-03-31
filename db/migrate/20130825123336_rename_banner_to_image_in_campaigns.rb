class RenameBannerToImageInCampaigns < ActiveRecord::Migration
  def up
    rename_column :campaigns, :banner, :image
  end

  def down
    rename_column :campaigns, :image, :banner
  end
end
