class FixNilPtypesForPackages < ActiveRecord::Migration
  def up
    Package.where(:ptype => '').update_all(:ptype => :sms)
  end

  def down
  end
end
