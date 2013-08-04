class SessionsController < ApplicationController
  layout 'public'
  def new
  end

  # sign the user in
  def create
    user = User.where(email: params[:email]).first.try(:authenticate, params[:password])
    if user
      reset_session
      set_current_user(user)
      redirect_to(root_path, notice: 'Signed in')
    else
      request.flash[:error] = 'You should just give up!'
      render :new
    end
  end

  def destroy
    reset_session
    render :new
  end
end
