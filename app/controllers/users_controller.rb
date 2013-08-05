class UsersController < ApplicationController

  before_filter :authenticate_user
  before_filter :set_user, only: [:edit, :update]

  def index
    authorize! :create, User
    @users = User.all
  end

  def edit
    @customer = @user.customer
  end

  def update
    user_params = params.require(:user).permit!
    @customer = @user.customer
    @user.email = user_params[:email]
    @user.password = user_params[:password]
    @user.password_confirmation = user_params[:password_confirmation]
    if @user.save
      redirect_to(edit_user_path(@user), notice: 'Email and password updated')
    else
      render(:edit)
    end
  end

  def new
    @customer = Customer.find_by_id(params[:customer_id])
    if @customer.email.present?
      @user = User.new(email: @customer.email, customer_id: @customer.id)
    else
      redirect_to(customer_path(@customer), alert: 'Customer needs an email address before a user account can be created for them.')
    end
  end

  def create
    authorize! :create, User
    user_params = params.require(:user).permit!
    if user_params[:password].blank? && user_params[:password_confirmation].blank?
      user_params[:password] = user_params[:password_confirmation] = SecureRandom.urlsafe_base64.slice(0, 8)
    end
    @user = User.new(user_params)
    @customer = @user.customer
    if @user.save
      UserMailer.account_created(@user.id, user_params[:password]).deliver
      redirect_to(customer_path(@customer), notice: 'User account created with read-only privileges')
    else
      render(:edit)
    end
  end

  def destroy
    authorize! :destroy, User
    @user = User.find(params[:id])
    if @user.destroy
      msg = "User account for #{@user.email} has been deleted"
      if @user.customer
        redirect_to(customer_path(@user.customer), notice: msg)
      else
        redirect_to(users_path, notice: msg)
      end
    else
      render(:edit)
    end
  end

  private

  def set_user
    @user = if current_user.luna?
              User.find(params[:id])
            else
              current_user
            end
  end
end
