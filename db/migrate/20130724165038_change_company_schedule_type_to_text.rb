class ChangeCompanyScheduleTypeToText < ActiveRecord::Migration
  def up
    change_column :companies, :schedule, :text
  end

  def down
    change_column :companies, :schedule, :string
  end
end
