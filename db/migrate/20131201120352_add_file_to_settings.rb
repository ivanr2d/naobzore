class AddFileToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :file, :string
  end
end
