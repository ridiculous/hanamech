class Car < ActiveRecord::Base
  belongs_to :customer
  has_many :workorders, dependent: :destroy

  validates :car_make, :car_model, :customer_id, presence: true

  accepts_nested_attributes_for :customer

  attr_accessor :year_make_model
  def name
    wip = "#{car_make} #{car_model}"
    wip.prepend("#{year} ") if year.present?
    wip
  end
end
