class ChangeGoodsStateTypeToEnum < ActiveRecord::Migration
  def up
    change_column :goods, :state, :enum, :limit => [:new, :used], :default => :new
    ActiveRecord::Base.connection.execute('UPDATE goods SET state = "new"')
  end

  def down
    change_column :goods, :state, :string, :null => true
  end
end
