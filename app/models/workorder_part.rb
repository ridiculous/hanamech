class WorkorderPart < ActiveRecord::Base
  belongs_to :part
  belongs_to :workorder

  accepts_nested_attributes_for :part

  def self.calc_total
    where(nil).sum(&:cost)
  end

  def cost
    (quantity.to_f || 0) * (part.try(:price).to_f || 0)
  end
end
