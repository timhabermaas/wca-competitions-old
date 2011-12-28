module RegistrationsHelper
  def format_time(time)
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

  def format_mbld(result) # TODO is this the right place? seperate wca helper?
    s = "%010d" % result
    diff = 99 - s[1..2].to_i
    missed = s[-2..-1].to_i
    solved = diff + missed
    attempted = solved + missed
    time = s[3..7].to_i
    "#{solved}/#{attempted} in #{time == 99999 ? "?" : format_time(time * 100)}"
  end

  def format_result(result, event)
    return "" if result.nil?

    case event.wca
    when "333fm"
      result.to_s
    when "333mbf"
      format_mbld(result)
    else
      format_time(result)
    end
  end
end
