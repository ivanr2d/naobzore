class AddColumnCategoryToFeedbacks < ActiveRecord::Migration
  def up
    remove_column :feedbacks, :annonce
    add_column :feedbacks, :category_id, :integer
  end
  def down
    remove_column :feedbacks, :category_id
    add_column :feedbacks, :annonce, :string
  end
end
