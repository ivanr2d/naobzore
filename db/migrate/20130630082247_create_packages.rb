class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name, :null => false
      t.enum :ptype, :limit => [:placing, :communication], :default => :placing
      t.integer :sms, :default => 0
      t.integer :calls, :default => 0
      t.integer :goods_and_services, :default => 0
      t.integer :jobs, :default => 0
      t.integer :campaigns, :default => 0
      t.integer :price, :null => false
      t.timestamps
    end
  end
end
