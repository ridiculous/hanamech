class Customer < ActiveRecord::Base

  SEARCHABLE_FIELDS = %w[name phone email car]

  has_one :user
  has_many :cars, dependent: :destroy
  has_many :workorders, through: :cars
  validates :name, presence: true

  def full_name
    "#{last_name}, #{first_name}"
  end

  def to_s
    first_name
  end

  def set_name
     self.name = "#{first_name} #{last_name}".strip
  end

  def address
    "#{street}, #{city_state}"
  end

  class << self

    def searchable_fields
      Customer::SEARCHABLE_FIELDS.dup
    end

    def find_by_fullname(customer_name)
      all.where('first_name = ? and last_name = ?', *customer_name.split(/, /)).first if customer_name =~ /, /
    end

    def search(params)
      if params[:users_search].present?
        all.where(*search_query(params))
      else
        all
      end
    end

    def search_query(params)
      users_search = params[:users_search].strip
      case params[:cat]
        when 'name' then
          first_name, last_name = users_search.split(/\s/)
          if last_name
            return "first_name ilike ? and last_name ilike ?", '%'+first_name.strip+'%', '%'+last_name.strip+'%'
          else
            return "first_name ilike ? or last_name ilike ?", '%'+users_search+'%', '%'+users_search+'%'
          end
        when 'phone' then
          return "phone_number ilike :q or cell_number ilike :q", q: '%' + users_search + '%'
        when 'car' then
          return "cars.car_make ilike :q OR cars.car_model ilike :q", q: '%'+users_search+'%'
        else
          return "email ilike ?", '%' + users_search + '%'
      end
    end
  end
end