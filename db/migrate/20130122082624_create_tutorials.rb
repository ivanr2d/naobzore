class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.string :title, :null => false
      t.text :text
      t.string :link, :null => false
      t.integer :file_type, :limit => 1, :null => false

      t.timestamps
    end
  end
end
