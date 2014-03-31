class AddIcqAndPreferedContactToUsers < ActiveRecord::Migration
  def change
    add_column :users, :icq, :integer
    add_column :users, :prefered_contact, :string, :limit => 50
  end
end
