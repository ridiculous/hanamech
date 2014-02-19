class WorkordersController < ApplicationController

  before_filter :set_workorder, except: :index

  before_filter only: [:create, :update] do
    wo = params[:workorder]
    wo[:date].try(:gsub!, %r{(\d{2})/(\d{2})/(\d+)}, '\3-\1-\2')
  end

  def index
    @car = Car.find_by_id(params[:car_id])
    @workorders = if @car
                    @customer = @car.customer
                    @total = @car.workorders.map(&:real_total).reduce(:+)
                    @car.workorders
                  else
                    Workorder.where(nil)
                  end
    @workorders = @workorders.includes(:car, :customer, :jobs) \
                  .order('date DESC, car_id').page(params[:page]).per_page(Constants::PER_PAGE)
  end

  def show
    @workorder.prepare
    respond_to do |format|
      format.html do
        render(:edit)
      end
      format.pdf do
        file_name = "#{Constants::NAME.downcase.gsub(/\W+/, '_')}_workorder_#{@workorder.id}"
        render :pdf => file_name,
               :formats => [:pdf],
               :orientation => 'Landscape',
               page_size: 'Letter'
      end
    end
  end

  def new
    @workorder.prepare
    @workorder.date = Date.today
  end

  def edit
    @workorder.prepare
  end

  def create
    authorize! :create, @workorder
    if @workorder.update_attributes(params.require(:workorder).permit!)
      redirect_to(car_workorders_path(@workorder.car), notice: 'Workorder created')
    else
      @workorder.prepare
      render(:new)
    end
  end

  def update
    authorize! :update, @workorder
    if @workorder.update_attributes(params.require(:workorder).permit!)
      redirect_to(edit_car_workorder_path(@workorder.car, @workorder), :notice => "Workorder updated. #{view_context.link_to('Back to workorders', view_context.my_wos_path)}")
    else
      @workorder.prepare
      render(:edit)
    end
  end

  def destroy
    authorize! :destroy, @workorder
    @workorder.destroy
    redirect_to(car_workorders_path(@car), notice: 'Work Order has been deleted')
  end

  def printable
    @workorder = Workorder.find(params[:id])
    render "printable", :layout => false
  end

  private

  def set_workorder
    @workorder = if params[:car_id]
                   Car.find(params[:car_id]).workorders
                 else
                   Workorder.where(nil)
                 end
    @workorder = @workorder.includes(:jobs, :parts).find_or_initialize(params[:id])
    @car = @workorder.car
    @customer = @car.customer if @car
    @workorder.odometer ||= @car.try(:odometer)
  end

  def access_denied
    redirect_to(car_workorders_path(@car), alert: 'You are not authorized to update workorders')
  end

end
