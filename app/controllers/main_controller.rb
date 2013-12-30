class MainController < ApplicationController

  def index
    if current_user.luna?
      @num_customers = Customer.count
      @num_cars = Car.count
      @num_workorders = Workorder.count
      @selected_customers = []
      if params[:users_search].present?
        @selected_customers = Customer.includes(:cars).search(params) \
      .order(:last_name, 'cars.car_make').page(params[:page]).per_page(Constants::PER_PAGE)
      end
    else
      redirect_to customer_path(current_user.customer)
    end
  end
end
