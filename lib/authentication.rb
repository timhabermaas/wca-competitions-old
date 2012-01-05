module Authentication
  def self.included(controller)
    controller.send :helper_method, :current_user, :logged_in?, :redirect_to_target_or_default

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_user=(user)
      @current_user = user
      session[:user_id] = user.try :id
    end

    def logged_in?
      !!current_user
    end

    def redirect_to_target_or_default(default, *options)
      redirect_to(session[:redirect_to] || default, *options)
      session[:redirect_to] = nil
    end

    private
    def store_target_location
      session[:redirect_to] = request.url
    end
  end
end
