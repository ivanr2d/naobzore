class AddColumnPossitionToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :position, :integer
    add_column :categories, :meta_description, :string
    add_column :categories, :meta_keywords, :string
    add_column :categories, :meta_title, :string
  end
  def down
    remove_column :categories, :position
    remove_column :categories, :meta_description
    remove_column :categories, :meta_keywords
    remove_column :categories, :meta_title
  end
end
