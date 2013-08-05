class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to(logout_path)
  end

  helper_method :set_customer_mode, :in_customer_mode, :current_user
  hide_action :set_customer_mode, :in_customer_mode

  layout :provision

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
    @current_user ||= User.find_by!(auth_token: cookies[:auth_token]) if cookies[:auth_token]
  end

  private

  def authenticate_user
    if !session || !current_user
      redirect_to(login_path, alert: 'Please sign in first') and return
    end
  end

  def provision
    if current_user.try(:luna?)
      'application'
    else
      'guest'
    end
  end

end