class RemoveImageFromEntities < ActiveRecord::Migration
  def up
    [:goods, :services, :jobs, :campaigns, :news].each do |table|
      remove_column table, :image
    end
  end

  def down
  end
end
