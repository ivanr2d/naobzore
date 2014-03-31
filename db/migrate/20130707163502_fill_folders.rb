class FillFolders < ActiveRecord::Migration
  def up
    Company.all.each do |company|
      company.folders.create([{:name => 'group1'}, {:name => 'group2'}])
    end
  end

  def down
    Folder.delete_all
  end
end
