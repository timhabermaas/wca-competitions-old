class SessionsController < ApplicationController
  def create
    user = User.find_by_email params[:email]
    if user.try(:authenticate, params[:password])
      self.current_user = user
      redirect_to_target_or_default admin_dashboard_path, :notice => "Successfully logged in."
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
