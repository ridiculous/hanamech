class Job < ActiveRecord::Base
  extend ActiveRecordClassExtensions

  has_many :workorder_jobs
  has_many :workorders, through: :workorder_jobs

  scope :by_name, ->(le_name) { where('UPPER(name) = UPPER(?)', le_name) }

end