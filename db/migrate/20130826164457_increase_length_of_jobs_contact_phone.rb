class IncreaseLengthOfJobsContactPhone < ActiveRecord::Migration
  def up
    change_column :jobs, :contact_phone, :string, :length => 255
    change_column :jobs, :contact_fax, :string, :length => 255
  end

  def down
    change_column :jobs, :contact_phone, :string, :length => 32
    change_column :jobs, :contact_fax, :string, :length => 32
  end
end
