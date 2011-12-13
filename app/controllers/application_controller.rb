class ApplicationController < ActionController::Base
  protect_from_forgery
  load_and_authorize_resource

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.try :id
  end

  def logged_in?
    !!current_user
  end
  helper_method :logged_in?
end
