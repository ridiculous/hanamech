class Car < ActiveRecord::Base
  belongs_to :customer
  has_many :workorders, dependent: :destroy

  validates :car_make, :car_model, :customer_id, presence: true

  def name
    wip = "#{car_make} #{car_model}"
    wip.prepend("#{year} ") if year.present?
    wip
  end
end
