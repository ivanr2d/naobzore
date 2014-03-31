class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name, :null => false
      t.integer :company_id

      t.timestamps
    end
  end
end
