class ChangeTypeColumnTypeToCategories < ActiveRecord::Migration
  def up
    remove_column :categories, :cat_type
    add_column :categories, :cat_type, :string, :limit => 16
    add_column :categories, :alias, :string, :limit => 48
  end

  def down
    remove_column :categories, :cat_type
    add_column :categories, :cat_type, :string, :limit => 16
    remove_column :categories, :alias
  end
end
