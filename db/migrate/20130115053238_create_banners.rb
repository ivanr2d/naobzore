class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :banner, :null => false
      t.string :link, :null => false
      t.integer :place, :null => false, :limit => 1

      t.timestamps
    end
  end
end
