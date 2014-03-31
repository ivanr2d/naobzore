class AddTranslitToEntitiesTables < ActiveRecord::Migration
  def initialize
    @tables = [:goods, :services, :jobs, :campaigns, :news]
  end

  def up
    @tables.each do |table|
      add_column table, :translit, :string, :null => false, :after => :name
      add_index table, :translit
    end
  end

  def down
    @tables.each do |table|
      remove_index table, :translit
      remove_column table, :translit
    end
  end
end
