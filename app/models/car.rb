class Car < ActiveRecord::Base
  belongs_to :customer
  has_many :workorders, dependent: :destroy

  accepts_nested_attributes_for :customer, allow_destroy: true

  validates :year_make_model, :customer, presence: true

  after_validation :set_year_make_model

  def self.all_as_json(the_customer=nil)
    ActiveRecord::Base.connection.select_all(query(the_customer)).to_a
  end

  def self.query(the_customer=nil)
    q = "SELECT year_make_model, odometer, vin_number, engine_size FROM #{quoted_table_name}"
    q += "WHERE customer_id = #{the_customer.to_i}" if the_customer
    q
  end

  def name
    wip = "#{car_make} #{car_model}"
    wip.prepend("#{year} ") if year.present?
    wip
  end

  def set_year_make_model
    tmp_year, self.car_make, *tmp_model = year_make_model.to_s.split(/\s/)
    self.year = tmp_year.try(:gsub, /[^\d]+/, '')
    self.car_model = tmp_model.join(' ')
  end

end
