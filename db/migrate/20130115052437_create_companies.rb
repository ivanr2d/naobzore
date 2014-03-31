class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :user_id, :null => false, :limit => 8
      t.string :name, :null => false, :limit => 128
      t.string :legal_name, :limit => 128
      t.string :address, :limit => 128
      t.string :phone, :limit => 24
      t.text :description
      t.string :logotype
      t.text :images

      t.timestamps
    end
  end
end
