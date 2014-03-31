class CreateTableFavoritesYetOneTime < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id, :null => false
      t.integer :entity_id, :null => false
      t.integer :status, :limit => 1, :null => false
      t.string :entity_type, :limit => 16, :null => false

      t.timestamps
    end
  end
end
