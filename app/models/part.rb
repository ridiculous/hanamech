class Part < ActiveRecord::Base
  extend ActiveRecordByName

  has_many :workorder_parts
  has_many :workorders, through: :workorder_parts

  validates :name, presence: true

  before_destroy :empty_workorders?

  def self.all_as_json
    ActiveRecord::Base.connection.select_all("SELECT name, price FROM #{quoted_table_name}").to_a
  end

  def empty_workorders?
    workorders.empty?
  end

end
