class SessionsController < ApplicationController
  def create
    user = User.find_by_email params[:email]
    if user.try(:authenticate, params[:password])
      self.current_user = user
      flash[:notice] = "Successfully logged in."
      if session[:redirect_to]
        redirect_to session[:redirect_to]
        session[:redirect_to] = nil
      else
        redirect_to admin_dashboard_path
      end
    else
      flash.now.alert = "Invalid email or password!"
      render :new
    end
  end

  def destroy
    self.current_user = nil
    redirect_to root_path, :notice => "Successfully logged out."
  end
end
