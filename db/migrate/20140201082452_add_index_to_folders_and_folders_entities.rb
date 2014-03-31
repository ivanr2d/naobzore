class AddIndexToFoldersAndFoldersEntities < ActiveRecord::Migration
  def change
  	add_index :folders, :company_id
  	[:goods, :services, :campaigns].each { |table| add_index table, [:published, :folder_id] }
  end
end
