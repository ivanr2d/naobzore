class AddTitleToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :title, :string, :null => false, :after => :dual
  end
end
