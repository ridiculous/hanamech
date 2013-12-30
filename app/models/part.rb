class Part < ActiveRecord::Base
  extend ActiveRecordClassExtensions

  has_many :workorder_parts
  has_many :workorders, through: :workorder_parts

  scope :by_name, ->(le_name) { where('UPPER(name) = UPPER(?)', le_name) }
end
