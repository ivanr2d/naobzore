class AddMtypeToMessages < ActiveRecord::Migration
  def up
    add_column :messages, :mtype, :enum, :limit => [:message, :support, :complaint, :notification], :default => :message
    add_index :messages, :mtype
  end

  def down
    remove_column :messages, :mtype
  end
end
