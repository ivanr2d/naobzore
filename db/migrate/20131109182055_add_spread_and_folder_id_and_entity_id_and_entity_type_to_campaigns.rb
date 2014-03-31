class AddSpreadAndFolderIdAndEntityIdAndEntityTypeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :spread, :enum, :limit => [:all, :folder, :entity], :default => :all
    add_column :campaigns, :folder_id, :integer
    add_column :campaigns, :entity_id, :integer
    add_column :campaigns, :entity_type, :string
  end
end
