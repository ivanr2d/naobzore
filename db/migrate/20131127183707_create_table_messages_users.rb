class CreateTableMessagesUsers < ActiveRecord::Migration
  def up
    create_table :messages_users, :id => false do |t|
      t.integer :message_id, :null => false
      t.integer :user_id, :null => false
    end
    add_index :messages_users, [:message_id, :user_id]
  end

  def down
    drop_table :messages_users
  end
end
