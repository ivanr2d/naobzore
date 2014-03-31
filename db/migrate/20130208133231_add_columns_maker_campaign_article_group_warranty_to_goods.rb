class AddColumnsMakerCampaignArticleGroupWarrantyToGoods < ActiveRecord::Migration
  def up
    add_column :goods, :maker, :string, :limit => 64
    add_column :goods, :campaign, :integer
    add_column :goods, :article, :integer
    add_column :goods, :group, :integer
  end
  
  def down
    remove_column :goods, :maker
    remove_column :goods, :campaign
    remove_column :goods, :article
    remove_column :goods, :group
  end
end
