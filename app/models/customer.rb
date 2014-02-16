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
          return "name ilike ?", "%#{users_search}%"
        when 'phone' then
          return "phone_number ilike :q or cell_number ilike :q", q: '%' + users_search + '%'
        when 'car' then
          return "cars.year_make_model ilike ?", '%'+users_search+'%'
        else
          return "email ilike ?", '%' + users_search + '%'
      end
    end

    def all_as_json
      ActiveRecord::Base.connection.select_all("SELECT name, phone_number, street, city_state FROM #{quoted_table_name}").to_a
    end
  end
end