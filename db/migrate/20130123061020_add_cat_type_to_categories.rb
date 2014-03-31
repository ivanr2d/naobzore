# coding: utf-8

class AddCatTypeToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :cat_type, :integer
  end
  
  def down
    remove_column :categories, :cat_type
  end
end
