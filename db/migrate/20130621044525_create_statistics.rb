class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.integer :good_id, :null => false
      t.integer :user_id
      t.string :ip, :null => false, :limit => 15
      t.integer :time, :null => false
    end
    add_index :statistics, :good_id
    add_index :statistics, :user_id
    add_index :statistics, :time
  end
end
