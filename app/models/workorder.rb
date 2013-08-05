class Workorder < ActiveRecord::Base

  belongs_to :car

  has_one :customer, through: :car

  validates :details, :car_id, presence: true

  def real_total
    Float(total) rescue 0
  end
end
