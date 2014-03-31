class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :category_id, :null => false, :limit => 8
      t.integer :company_id, :null => false, :limit => 8
      t.string :name, :null => false, :limit => 128
      t.text :description
      t.decimal :salary_from, :precision => 8, :scale => 4
      t.decimal :salary_to, :precision => 8, :scale => 4

      t.timestamps
    end
  end
end
