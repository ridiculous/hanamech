class CustomersController < ApplicationController

  before_filter :set_customer, only: [:show, :edit, :destroy, :update]

  def index
    if current_user.luna?
      respond_to do |format|
        format.html do
          @customers = Customer.order("LOWER(#{sort_column}) #{sort_direction}, id DESC") \
                               .page(params[:page]).per_page(Constants::PER_PAGE)
        end
        format.json do
          render json: Customer.all_as_json
        end
      end
    else
      redirect_to(customer_path(current_user.customer))
    end
  end

  def show
  end

  def new
    @customer = Customer.new
  end

  def edit
    fail 'Football' if params[:id].to_i == 17
  end

  def create
    authorize! :create, @customer = Customer.new(params.require(:customer).permit!)
    if @customer.save
      redirect_to(customer_path(@customer, clear: 'customers'), :notice => 'Customer successfully created')
    else
      render "new"
    end
  end

  def update
    authorize! :update, @customer
    if @customer.update_attributes(params.require(:customer).permit!)
      redirect_to(customer_path(@customer, clear: 'customers'), :notice => 'Record updated')
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @customer
    @customer.destroy
    redirect_to(customers_path, notice: "#{@customer} has been deleted")
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def sort_column
    super('name')
  end
end
