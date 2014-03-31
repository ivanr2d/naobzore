class RenameTitleToNameInGoodsAndNews < ActiveRecord::Migration
  def change
    rename_column :goods, :title, :name
    rename_column :news, :title, :name
  end
end
