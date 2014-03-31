class CreateConstructorTracks < ActiveRecord::Migration
  def change
    create_table :constructor_tracks do |t|
      t.string :category, :null => false
      t.string :video, :null => false

      t.timestamps
    end
  end
end
