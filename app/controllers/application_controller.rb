class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  rescue_from CanCan::AccessDenied do
    session["user_return_to"] = request.url
    redirect_to new_user_session_path, :alert => "You're not authorized to access this page!"
  end

  def load_competition
    @competition ||= Competition.find_by_subdomain! request.subdomain
  end
  helper_method :load_competition

  def competition_present?
    load_competition
    true
  rescue ActiveRecord::RecordNotFound
    false
  end
  helper_method :competition_present?

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { :locale => I18n.locale }
  end
end
