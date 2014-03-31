class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :title, :null => false
      t.string :annonce
      t.text :comment, :null => false
      t.text :plus, :null => false
      t.text :minus, :null => false
      t.integer :user_id, :null => false
      t.integer :contentment, :null => false
      t.integer :entity_id, :null => false
      t.string :entity_type, :null => false, :limit => 32

      t.timestamps
    end
  end
end
