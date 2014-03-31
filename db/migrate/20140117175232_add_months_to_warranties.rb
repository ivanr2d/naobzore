class AddMonthsToWarranties < ActiveRecord::Migration
  def change
    add_column :warranties, :months, :integer, :null => false
  end
end
