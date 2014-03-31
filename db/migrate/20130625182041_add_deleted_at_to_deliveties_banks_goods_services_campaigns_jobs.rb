class AddDeletedAtToDelivetiesBanksGoodsServicesCampaignsJobs < ActiveRecord::Migration
  def change
    add_column :deliveties, :deleted_at, :time
    add_column :banks, :deleted_at, :time
    add_column :goods, :deleted_at, :time
    add_column :services, :deleted_at, :time
    add_column :campaigns, :deleted_at, :time
    add_column :jobs, :deleted_at, :time
  end
end
