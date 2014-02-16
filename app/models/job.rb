class Job < ActiveRecord::Base
  extend ActiveRecordByName

  has_many :workorder_jobs
  has_many :workorders, through: :workorder_jobs

  validates :name, presence: true

  before_destroy :empty_workorders?

  def self.all_as_json
    ActiveRecord::Base.connection.select_all("SELECT name, hours FROM #{quoted_table_name}").to_a
  end

  def empty_workorders?
    workorders.empty?
  end

end