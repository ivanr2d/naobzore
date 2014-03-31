class AddColumnFioToUser < ActiveRecord::Migration
  def up
    add_column :users, :fio, :string
  end
  def down
    remove_column :users, :fio
  end
end
