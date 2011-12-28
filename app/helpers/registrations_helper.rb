module RegistrationsHelper
  def format_time(time)
    return "" if time.nil?
    seconds = time / 100.0
    minutes = (seconds / 60).to_i
    hours = minutes / 60
    if seconds < 60
      "%.2f" % (seconds)
    elsif minutes < 60
      "%d:%05.2f" % [minutes, seconds - minutes * 60]
    else
      "%d:%02d:%05.2f" % [hours, minutes - hours * 60, seconds - minutes * 60]
    end
  end
  alias_method :ft, :format_time
end
