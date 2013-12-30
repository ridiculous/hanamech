class Job < ActiveRecord::Base
  extend ActiveRecordByName

  has_many :workorder_jobs
  has_many :workorders, through: :workorder_jobs

end