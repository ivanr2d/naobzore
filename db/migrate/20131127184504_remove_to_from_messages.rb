class RemoveToFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :to_id
  end

  def down
    add_column :messages, :to_id, :integer
  end
end
