class Part < ActiveRecord::Base
  extend ActiveRecordByName

  has_many :workorder_parts
  has_many :workorders, through: :workorder_parts

  validates :name, presence: true

end
