class ChangeCampaignsModeTypeToEnum < ActiveRecord::Migration
  def up
    change_column :campaigns, :mode, :enum, :limit => [:action, :sale], :default => :action
  end

  def down
    change_column :campaigns, :mode, :integer
  end
end
