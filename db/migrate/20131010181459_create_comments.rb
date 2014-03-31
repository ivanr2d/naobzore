class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id, :null => false
      t.integer :entity_id, :null => false
      t.string :entity_type, :null => false
      t.text :text, :null => false

      t.timestamps
    end
  end
end
