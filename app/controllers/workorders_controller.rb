class WorkordersController < ApplicationController

  before_filter :set_workorder, except: :index
  before_filter :bootsrap_data, only: [:new, :edit, :update, :create]

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
                    Workorder.includes(:car)
                  end
    @workorders = @workorders.order('date DESC, car_id').page(params[:page]).per_page(Constants::PER_PAGE)
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        @workorder.prepare
        file_name = "#{Constants::NAME.downcase.gsub(/\W+/, '_')}_workorder_#{@workorder.id}"
        pdf_file = Rails.root.join('private', 'workorders', "#{file_name}.pdf")
        render :pdf => file_name,
               :formats => [:pdf],
               :save_to_file => pdf_file,
               :save_only => true,
               :orientation => 'Landscape',
               page_size: 'Letter'

        send_file(pdf_file, type: 'application/pdf')
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
                   Car.find(params[:car_id]).workorders.find_or_initialize(params[:id])
                 else
                   Workorder.find_or_initialize(params[:id])
                 end
    @car = @workorder.car
    @customer = @car.customer if @car
    @workorder.odometer ||= @car.try(:odometer)
  end

  def bootsrap_data
    @part_names = select_name_from('parts')
    @customer_names = select_name_from('customers')
    @job_names = select_name_from('jobs')
  end

  def select_name_from(table_name)
    ActiveRecord::Base.connection.select_all("SELECT name FROM #{table_name}").map { |x| x['name'] }
  end

  def access_denied
    redirect_to(car_workorders_path(@car), alert: 'You are not authorized to update workorders')
  end

end
