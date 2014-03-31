# encoding: utf-8

class CompaniesResume < ActiveRecord::Base
  attr_accessible :company_id, :job_id, :resume_id

  belongs_to :job
  belongs_to :company
  belongs_to :resume

  validates :company_id, :resume_id, :presence => true
  # TODO uniqueness validations

  # TODO where('job_id != 0) works faster
  scope :with_job_id, where('job_id IS NOT NULL')
end
