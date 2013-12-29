class WorkorderJob < ActiveRecord::Base
  belongs_to :job
  belongs_to :workorder

  accepts_nested_attributes_for :job

  def real_total
    Float(total) rescue 0
  end

end
