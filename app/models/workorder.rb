class Workorder < ActiveRecord::Base

  PARTS = 22
  JOBS = PARTS - 7

  belongs_to :car

  has_one :customer, through: :car

  has_many :workorder_parts
  has_many :parts, through: :workorder_parts
  has_many :workorder_jobs
  has_many :jobs, through: :workorder_jobs

  accepts_nested_attributes_for :workorder_parts, allow_destroy: true
  accepts_nested_attributes_for :workorder_jobs, allow_destroy: true
  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :car

  validates :car_id, presence: true

  attr_accessor :misc_supplies, :labor_total, :sublet_repairs, :paid_in_advance, :tax_total, :parts_total,
                :authorized_by, :balance_due

  def real_total
    Float(total) rescue 0
  end

  def prepare
    car || build_car
    car.customer || car.build_customer
    build_parts
    build_jobs
  end

  def build_parts
    (PARTS - workorder_parts.length).times.each do
      workorder_parts.build.build_part
    end
  end

  def build_jobs
    (JOBS - workorder_jobs.length).times.each do
      workorder_jobs.build.build_job
    end
  end
end
