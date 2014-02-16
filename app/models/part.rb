class Part < ActiveRecord::Base
  extend ActiveRecordByName

  has_many :workorder_parts
  has_many :workorders, through: :workorder_parts

  validates :name, presence: true

  before_destroy :empty_workorders?

  def empty_workorders?
    workorders.empty?
  end

end
