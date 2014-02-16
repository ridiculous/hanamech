class Job < ActiveRecord::Base
  extend ActiveRecordByName

  has_many :workorder_jobs
  has_many :workorders, through: :workorder_jobs

  validates :name, presence: true

  before_destroy :empty_workorders?

  def empty_workorders?
    workorders.empty?
  end

end