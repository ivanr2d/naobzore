class AddColumnImageToEntities < ActiveRecord::Migration
  def up
    remove_column :goods, :images
    add_column :goods, :image, :string
    add_column :goods, :characteristics, :text
    
    remove_column :companies, :images
    
    add_column :jobs, :image, :string
    add_column :services, :image, :string
  end
  
  def down
    remove_column :goods, :image
    remove_column :goods, :characteristics
    add_column :goods, :images, :integer
    
    add_column :companies, :images, :text
    
    remove_column :jobs, :image
    remove_column :services, :image
  end
end
