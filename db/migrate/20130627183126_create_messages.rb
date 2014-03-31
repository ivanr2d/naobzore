class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :text, :null => false
      t.integer :from_id, :null => false
      t.integer :to_id
      t.timestamps
    end
  end
end
