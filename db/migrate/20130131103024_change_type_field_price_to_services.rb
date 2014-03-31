class ChangeTypeFieldPriceToServices < ActiveRecord::Migration
  def up
    remove_column :services, :cost_from
    remove_column :services, :cost_to
    remove_column :jobs, :salary_from
    remove_column :jobs, :salary_to
    
    add_column :services, :cost_from, :integer
    add_column :services, :cost_to, :integer
    add_column :jobs, :salary_from, :integer
    add_column :jobs, :salary_to, :integer
  end

  def down
    remove_column :services, :cost_from
    remove_column :services, :cost_to
    remove_column :jobs, :salary_from
    remove_column :jobs, :salary_to
    
    add_column :services, :cost_from, :integer
    add_column :services, :cost_to, :integer
    add_column :jobs, :salary_from, :integer
    add_column :jobs, :salary_to, :integer
  end
end
