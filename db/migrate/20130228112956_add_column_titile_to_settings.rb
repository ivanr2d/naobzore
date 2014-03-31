class AddColumnTitileToSettings < ActiveRecord::Migration
  def up
    add_column :settings, :title, :string, :limit => 128
  end
  
  def down
    remove_column :settings, :title
  end
end
