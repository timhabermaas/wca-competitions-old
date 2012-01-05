class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery

  before_filter :set_locale

  rescue_from CanCan::AccessDenied do
    store_target_location
    redirect_to login_path, :alert => "You're not authorized to access this page!"
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { :locale => I18n.locale }
  end
end
