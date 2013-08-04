class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :set_customer_mode, :in_customer_mode, :current_user
  hide_action :set_customer_mode, :in_customer_mode

  def set_customer_mode
    @in_customer_mode = @customer.present? && @customer.persisted?
  end

  def in_customer_mode
    @in_customer_mode
  end

  def set_current_user(user)
    session[:user_token] = user.id * 2 if session
  end

  def current_user
    @current_user ||= User.find(session[:user_token] / 2) if session[:user_token]
  end

  private

  def authenticate_user
    if !session || !current_user
      redirect_to(login_path, alert: 'Please sign in first') and return
    end
  end

end