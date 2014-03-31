class RenameTitleToNameInFeedbacks < ActiveRecord::Migration
  def change
    rename_column :feedbacks, :title, :name
  end
end
