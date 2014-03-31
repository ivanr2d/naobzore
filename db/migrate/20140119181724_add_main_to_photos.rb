class AddMainToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :main,:boolean, :default => false
    add_index :photos, [:entity_id, :entity_type, :main]
  end
end
