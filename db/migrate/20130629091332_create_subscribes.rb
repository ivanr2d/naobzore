class CreateSubscribes < ActiveRecord::Migration
  def change
    create_table :subscribes do |t|
      t.integer :category_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
end
