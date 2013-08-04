class MainController < ApplicationController
  before_filter :authenticate_user

  def index
    @num_customers = Customer.count
    @num_cars = Car.count
    @num_workorders = Workorder.count
    @selected_customers = []
    if params[:users_search].present?
      @selected_customers = Customer.includes(:cars).search(params) \
      .order(:last_name, 'cars.car_make').page(params[:page]).per_page(Constants::PER_PAGE)
    end
  end
end
