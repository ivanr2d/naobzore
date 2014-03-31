class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :entity_id
      t.string :entity_type, :limit => 32
      t.integer :user_id

      t.timestamps
    end
  end
end
