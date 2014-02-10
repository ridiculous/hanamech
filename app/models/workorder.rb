class Workorder < ActiveRecord::Base

  PARTS = 22
  JOBS = PARTS - 7

  belongs_to :car

  has_one :customer, through: :car

  has_many :workorder_parts, dependent: :destroy
  has_many :workorder_jobs, dependent: :destroy
  has_many :jobs, through: :workorder_jobs
  has_many :parts, through: :workorder_parts

  accepts_nested_attributes_for :workorder_parts, allow_destroy: true, reject_if: :incomplete_item?
  accepts_nested_attributes_for :workorder_jobs, allow_destroy: true, reject_if: :incomplete_item?
  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :car, allow_destroy: true

  validates :car, :date, presence: true

  after_validation :copy_odometer_to_car

  class << self
    def find_or_initialize(record_id=nil)
      record_id.present? ? find(record_id) : new
    end
  end

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

  def incomplete_item?(obj)
    suspect = obj.each_value.detect { |val| val.blank? unless val.respond_to?(:values) }
    if suspect && obj.has_key?(:id)
      !(obj[:_destroy] = true) # false
    else
      suspect
    end
  end

  def copy_odometer_to_car
    car.odometer = odometer if car && odometer.to_i > car.try(:odometer).to_i
  end

  def convert_to_v2
    destroy && return if car.nil?
    do_parts if workorder_parts.empty?
    do_jobs if workorder_jobs.empty?
    self.tax_total = tax.to_f
    self.labor_total = labor.to_f
    self.paid_in_advance = 0.0
    self.balance_due = total.to_f
    save!
  end

  def do_parts
    wo_mats = materials.split(/,\s|\r\n/) # comma or carriage return and new line
    len = wo_mats.length
    wo_mats.each do |mats|
      build_workorder_parts(mats, len)
    end
  end

  def do_jobs
    wo_details = details.split(/,\s|\r\n/) # comma or carriage return and new line
    len = wo_details.length
    wo_details.each do |dets|
      build_workorder_jobs(dets, len)
    end
  end

  def build_workorder_parts(mats, len)
    qt = get_quantity(mats)
    price = len == 1 ? parts_total : 0.0
    name =  mats.sub(Regexp.new("#{qt} "), '')
    return unless name.present?
    part = Part.find_or_initialize_by(name: name)
    unless part.persisted?
      part.price = price
      part.save
    end
    workorder_parts.create(part: part, quantity: qt, price: price)
  end

  def build_workorder_jobs(dets, len)
    price = len == 1 ? labor : 0.0
    job = Job.find_or_initialize_by(name: dets)
    unless job.persisted?
      job.hours = 1
      job.save
    end
    workorder_jobs.create(job: job, total: price, hours: 1)
  end

  def get_quantity(mats)
    if mats =~ /^(\d{1})\s/ # single digit = quantity
      $1
    else
      '1'
    end
  end
end


#{:car_attributes =>
#     {
#         "customer_attributes" =>
#          {
#              "name" => "Ryan Buckley",
#              "street" => "135 Alalele Place",
#              "phone_number" => "8082647381",
#              "city_state" => "8082647381"
#          },
#      "year_make_model" => "2014 VW Jetta SE",
#      "vin_number" => "4444badass55577",
#      "engine_size" => "2.0"
#     },
# :date => "Ryan Buckley",
# :workorder_parts_attributes =>
#     {"0" =>
#          {"quantity" => "1",
#           "part_attributes" => {"name" => "Oil Filter", "price" => "50.12"}},
#      "1" =>
#          {"quantity" => "4",
#           "part_attributes" => {"name" => "Quarts of Oil", "price" => "10.50"}},
#      "2" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "3" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "4" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "5" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "6" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "7" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "8" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "9" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "10" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "11" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "12" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "13" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "14" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "15" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "16" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "17" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "18" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "19" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "20" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}},
#      "21" => {"quantity" => "", "part_attributes" => {"name" => "", "price" => ""}}},
# :odometer => "1234",
# :workorder_jobs_attributes =>
#     {"0" =>
#          {"job_attributes" => {"hours" => "1", "name" => "Oil Change"}, "total" => "50"},
#      "1" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "2" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "3" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "4" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "5" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "6" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "7" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "8" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "9" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "10" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "11" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "12" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "13" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""},
#      "14" => {"job_attributes" => {"hours" => "", "name" => ""}, "total" => ""}},
# :misc_supplies => "",
# :sublet_repairs => "",
# :paid_in_advance => "",
# :labor_total => "",
# :tax_total => "",
# :parts_total => "",
# :total => ""}