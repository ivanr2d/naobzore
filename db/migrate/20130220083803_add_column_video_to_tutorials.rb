class AddColumnVideoToTutorials < ActiveRecord::Migration
  def up
    add_column :tutorials, :local_file, :string
  end

  def down
    remove_column :tutorials, :local_file
  end
end
