class WorkorderPart < ActiveRecord::Base
  belongs_to :part
  belongs_to :workorder

  accepts_nested_attributes_for :part

  validates :quantity, numericality: true

end
