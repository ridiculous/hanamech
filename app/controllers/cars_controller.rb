class CarsController < ApplicationController
  before_filter :authenticate_user

  helper_method :sort_column, :sort_direction

  before_filter :set_car, except: :index

  include CarsHelper

  def index
    @customer = Customer.find_by_id(params[:customer_id])
    if @customer
      @cars = @customer.cars
    else
      @cars = Car.includes(:customer)
    end
    @cars = @cars.order("#{sort_column} #{sort_direction}").page(params[:page]).per_page(Constants::PER_PAGE)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @car.attributes = params.require(:car).permit!
    if @car.save
      redirect_to(my_car_path, :notice => 'Car was successfully created.')
    else
      render(:new)
    end
  end

  def update
    if @car.update_attributes(params.require(:car).permit!)
      redirect_to(my_car_path, :notice => 'Car was successfully updated.')
    else
      render(:edit)
    end
  end

  def destroy
    @car.destroy
    redirect_to(my_cars_path, notice: 'Car has been deleted')
  end

  private
  def sort_column
    Car.column_names.include?(params[:sort]) ? params[:sort] : "car_make"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def set_car
    @car = if params[:customer_id]
             @customer = Customer.find(params[:customer_id])
             if params[:id]
               @customer.cars.find(params[:id])
             else
               @customer.cars.new
             end
           else
             if params[:id]
               Car.find(params[:id])
             else
               Car.new
             end
           end
    @customer ||= @car.customer
  end
end
