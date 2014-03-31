class AddStatusToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :status, :enum, :limit => [:activation, :active, :locked], :default => :activation
  end
end
