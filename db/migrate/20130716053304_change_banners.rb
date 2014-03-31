class ChangeBanners < ActiveRecord::Migration
  def up
    remove_column :banners, :place
    remove_column :banners, :banner_type
    add_column :banners, :week, :integer, :limit => 2, :null => false
    add_column :banners, :type, :enum, :limit => [:home, :good, :service, :job, :enterprise, :news, :campaign, :response], :default => :home
  end

  def down
    remove_column :banners, :type
    remove_column :banners, :week
    add_column :banners, :banner_type, :string
    add_column :banners, :place, :integer
  end
end
