class SessionsController < ApplicationController
  layout 'public'
  def new
  end

  # sign the user in
  def create
    user = User.where(email: params[:email]).first.try(:authenticate, params[:password])
    if user
      reset_session
      user.update_attribute(:last_login, Time.now)
      set_current_user(user)
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to(root_path, notice: "Welcome #{user.email}".strip)
    else
      request.flash[:error] = 'You should just give up!'
      render :new
    end
  end

  def destroy
    cookies.delete(:auth_token)
    reset_session
    render :new
  end
end
