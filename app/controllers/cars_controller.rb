class CarsController < ApplicationController

  before_filter :set_car, except: :index

  def index
    @customer = current_user.customers.find_by_id(params[:customer_id])
    if @customer
      @cars = @customer.cars
    elsif current_user.luna?
      @cars = Car.where(nil)
    else
      redirect_to(logout_path) and return
    end
    @cars = @cars.includes(:customer) \
            .order("#{sort_column} #{sort_direction}").page(params[:page]).per_page(Constants::PER_PAGE)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    authorize! :create, @car
    @car.attributes = params.require(:car).permit!
    if @car.save
      redirect_to(my_car_path, :notice => 'Car was successfully created.')
    else
      render(:new)
    end
  end

  def update
    authorize! :update, @car
    if @car.update_attributes(params.require(:car).permit!)
      redirect_to(my_car_path, :notice => 'Car was successfully updated.')
    else
      render(:edit)
    end
  end

  def destroy
    authorize! :destroy, @car
    @car.destroy
    redirect_to(my_cars_path, notice: 'Car has been deleted')
  end

  private

  def sort_column
    super('car_make')
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
