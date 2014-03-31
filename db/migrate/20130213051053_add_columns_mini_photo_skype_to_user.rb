class AddColumnsMiniPhotoSkypeToUser < ActiveRecord::Migration
  def up
    add_column :users, :mini_photo, :string
    add_column :users, :skype, :string, :limit => 64
    add_column :users, :city, :string, :limit => 64
    add_column :users, :address, :string, :limit => 128
    add_column :users, :home_phone, :string, :limit => 32
    add_column :users, :mobil_phone, :string, :limit => 32
    add_column :users, :birthday, :date
    add_column :users, :web, :text
  end

  def down
    remove_column :users, :mini_photo
    remove_column :users, :skype
    remove_column :users, :city
    remove_column :users, :address
    remove_column :users, :home_phone
    remove_column :users, :mobil_phone
    remove_column :users, :birthday
    remove_column :users, :web
  end
end