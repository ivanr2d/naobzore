class CreateCompaniesResumes < ActiveRecord::Migration
  def change
    create_table :companies_resumes do |t|
      t.integer :job_id
      t.integer :company_id, :null => false
      t.integer :resume_id, :null => false
      t.enum :status, :limit => [:new, :responded, :rejected], :default => :new

      t.timestamps
    end
  end
end
