class AddDeletedAtToUsersAndCompanies < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :time
    add_column :companies, :deleted_at, :time
  end
end
