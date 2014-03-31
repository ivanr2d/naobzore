class ChangeColumnsToJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :probation
    remove_column :jobs, :education
    add_column :jobs, :probation, :string, :limit => 32
    add_column :jobs, :education, :string, :limit => 32
  end

  def down
    remove_column :jobs, :probation
    remove_column :jobs, :education
    add_column :jobs, :probation, :string, :limit => 32
    add_column :jobs, :education, :string, :limit => 32
  end
end
