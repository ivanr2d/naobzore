class AddColumnsGraphicExperienceEducationSexAddressToJobs < ActiveRecord::Migration
  def up
    add_column :jobs, :graphic, :integer #График работы
    add_column :jobs, :experience, :string #опыт
    add_column :jobs, :education, :integer #Образование
    add_column :jobs, :sex, :integer #Пол
    add_column :jobs, :age_from, :integer
    add_column :jobs, :age_to, :integer
    add_column :jobs, :address, :string
    add_column :jobs, :contact_face, :string
    add_column :jobs, :contact_phone, :string, :limit => 32
    add_column :jobs, :contact_fax, :string, :limit => 32
  end
  
  def down
    remove_column :jobs, :graphic
    remove_column :jobs, :experience
    remove_column :jobs, :education
    remove_column :jobs, :sex
    remove_column :jobs, :age_from
    remove_column :jobs, :age_to
    remove_column :jobs, :address
    remove_column :jobs, :contact_face
    remove_column :jobs, :contact_phone
    remove_column :jobs, :contact_fax
  end
end