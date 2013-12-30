class User < ActiveRecord::Base
  belongs_to :customer
  has_many :cars, through: :customer
  has_many :workorders, through: :customer
  has_secure_password
  before_create { generate_token(:auth_token) }

  validates :email, presence: true, uniqueness: true

  def customers
    luna? ? Customer.all : Customer.where(id: customer_id)
  end

  def cars
    luna? ? Car.all : super
  end

  def workorders
    luna? ? Workorder.all : super
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end