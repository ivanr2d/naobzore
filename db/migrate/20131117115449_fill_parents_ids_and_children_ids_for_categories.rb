class FillParentsIdsAndChildrenIdsForCategories < ActiveRecord::Migration
  def up
    Category.all.each do |category|
      category.parents_ids = category.parent_id if category.parent_id
      category.children_ids = Category.where(:parent_id => category.id).pluck(:id).join(',')
      category.children_ids = '0' if category.children_ids.empty?
      category.save(:validate => false)
    end
  end

  def down
    Category.update_all(:parents_ids => '0', :children_ids => '0')
  end
end
