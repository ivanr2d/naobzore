class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :null => false, :limit => 64
      t.string :password, :null => false, :limit => 32
      t.string :f_name, :limit => 64
      t.string :l_name, :limit => 64
      t.string :m_name, :limit => 64
      t.string :account_type, :null => false, :limit => 16
      t.integer :active, :null => false, :limit => 1
      t.string :registr_token, :limit => 32
      t.string :passw_token, :limit => 32

      t.timestamps
    end
  end
end
