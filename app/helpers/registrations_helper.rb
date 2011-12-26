module RegistrationsHelper
  def format_time(time)
    "%.2f" % (time / 100.0)
  end
  alias_method :ft, :format_time
end
