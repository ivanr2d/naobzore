class AddParentIdsAndChildrenIdsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :parents_ids, :string, :default => '0'
    add_index :categories, :parents_ids
    add_column :categories, :children_ids, :string, :default => '0'
  end
end
