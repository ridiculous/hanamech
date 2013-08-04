class CustomersController < ApplicationController
  before_filter :authenticate_user

  helper_method :sort_column, :sort_direction

  before_filter :set_customer, only: [:show, :edit, :destroy, :update]

  def index
    if params[:id]
      @customers = Customer.where("id = ?", params[:id]).order(sort_column + " " + sort_direction)
    else
      @customers = Customer.order(sort_column + " " + sort_direction).page(params[:page]).per_page(Constants::PER_PAGE)
    end
  end

  def show
  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create
    @customer = Customer.new(params.require(:customer).permit!)
    if @customer.save
      redirect_to(@customer, :notice => 'Customer successfully created')
    else
      render "new"
    end
  end

  def update
    if @customer.update_attributes(params.require(:customer).permit!)
      redirect_to(customer_path(@customer), :notice => 'Record updated')
    else
      render "edit"
    end
  end

  def destroy
    @customer.destroy
    redirect_to(customers_path, notice: "#{@customer} has been deleted")
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def sort_column
    Customer.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
