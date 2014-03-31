class AddColumnsSalaryFromToResume < ActiveRecord::Migration
  def up
    add_column :resumes, :salary_from, :integer
    add_column :resumes, :category_id, :integer
    add_column :resumes, :user_id, :integer
    add_column :resumes,  :name, :string
  end
  def down
    remove_column :resumes, :salary_from
    remove_column :resumes, :category_id
    remove_column :resumes, :user_id
    remove_column :resumes, :name
  end
end
