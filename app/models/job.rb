class Job < ActiveRecord::Base
  has_many :workorder_jobs
  has_many :workorders, through: :workorder_jobs
end
