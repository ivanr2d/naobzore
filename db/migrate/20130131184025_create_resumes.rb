class CreateResumes < ActiveRecord::Migration
  def change
    create_table :resumes do |t|
      t.string :f_name, :null => false, :limit => 100
      t.string :l_name, :null => false, :limit => 100
      t.string :m_name, :null => false, :limit => 100
      t.integer :sex, :null => false, :limit => 1
      t.date :birthday, :null => false
      t.string :photo
      t.string :mob_phone, :limit => 25
      t.string :home_phone, :limit => 25
      t.string :email, :limit => 50
      t.string :skype, :limit => 50
      t.string :icq, :limit => 15
      t.integer :type_connection, :limit => 2
      t.integer :family_status, :limit => 1
      t.integer :children, :limit => 1
      t.string :driving_permit, :limit => 1
      t.string :computer_user
      t.text :computer_skills
      t.text :recommendations
      t.text :progress
      t.text :about_me

      t.timestamps
    end
    add_column :jobs, :probation, :integer, :limit => 1
    add_column :jobs, :requirements, :text
  end
end
