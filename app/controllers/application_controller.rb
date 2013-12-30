class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to(logout_path)
  end

  helper_method :set_customer_mode, :in_customer_mode, :current_user, :sort_column, :sort_direction
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
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn("Could not find user in #{__method__}")
    nil
  end

  def sort_column(default='id')
    if controller_name.singularize.titleize.constantize.column_names.include?(params[:sort])
      params[:sort]
    else
      default
    end
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
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