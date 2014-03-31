class PolimorphyStatisticsTable < ActiveRecord::Migration
  def up
		rename_column :statistics, :good_id, :entity_id
		add_column :statistics, :entity_type, :string, :limit => 32
		ActiveRecord::Base.connection.execute('UPDATE statistics SET entity_type = "Good"')
		add_index :statistics, :entity_type
  end

  def down
		remove_column :statistics, :entity_type
		rename_column :statistics, :entity_id, :good_id
  end
end
