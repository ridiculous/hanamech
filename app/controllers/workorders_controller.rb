class WorkordersController < ApplicationController
  before_filter :authenticate_user
  before_filter :set_cars, only: [:edit, :update, :new, :create]
  before_filter :set_workorder, except: :index


  def index
    @car = Car.find_by_id(params[:car_id])
    @workorders = if @car
                    @customer = @car.customer
                    @total = @car.workorders.map(&:real_total).reduce(:+)
                    @car.workorders
                  else
                    Workorder.includes(:car)
                  end
    @workorders = @workorders.order('date DESC, car_id').page(params[:page]).per_page(Constants::PER_PAGE)
  end

  def show
  end

  def new
    @workorder.car || @workorder.build_car
  end

  def edit
  end

  def create
    authorize! :create, @workorder
    @workorder.attributes = params.require(:workorder).permit!
    if @workorder.save
      redirect_to(car_workorder_path(@workorder.car, @workorder), notice: 'Work Orders was successfully created')
    else
      render(:new)
    end
  end

  def update
    authorize! :update, @workorder
    if @workorder.update_attributes(params.require(:workorder).permit!)
      redirect_to(car_workorder_path(@workorder.car, @workorder), :notice => 'Work Order was successfully updated')
    else
      render "edit"
    end
  end

  def destroy
    authorize! :destroy, @workorder
    @workorder.destroy
    redirect_to(car_workorders_path(@car), notice: 'Work Orders has been deleted')
  end

  def printable
    @workorder = Workorder.find(params[:id])
    render "printable", :layout => false
  end

  private

  def set_cars
    @cars ||= Car.includes(:customer).group('customers.id', 'cars.id').order('customers.last_name').map do |car|
      ["#{car.customer.full_name} - #{car.car_make} #{car.car_model}", car.id]
    end
  end

  def set_workorder
    @workorder = if params[:car_id]
                   @car = Car.find(params[:car_id])
                   if params[:id]
                     @car.workorders.find(params[:id])
                   else
                     @car.workorders.new
                   end
                 else
                   if params[:id]
                     Workorder.find(params[:id])
                   else
                     Workorder.new
                   end
                 end
    @car ||= @workorder.car
    @customer = @car.customer if @car
  end

end
