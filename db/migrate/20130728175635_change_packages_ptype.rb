class ChangePackagesPtype < ActiveRecord::Migration
  def up
    change_column :packages, :ptype, :enum, :limit => [:placing, :sms, :minutes], :default => :placing
  end

  def down
    change_column :packages, :ptype, :enum, :limit => [:placing, :communication], :default => :placing
  end
end
