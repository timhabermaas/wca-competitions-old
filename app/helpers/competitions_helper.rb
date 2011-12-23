module CompetitionsHelper
  def date_range(dates)
    if same_day?(dates.first, dates.last)
      l dates.first, :format => :long
    elsif same_month?(dates.first, dates.last)
      format = t("date.formats.long")
      format.gsub!(/%e(.)?|%d/, l(dates.first, :format => :day) + " - " + l(dates.last, :format => :day))
      l(dates.first, :format => format)
    elsif same_year?(dates.first, dates.last)
      l(dates.first, :format => :day_month) + " - " + l(dates.last, :format => :day_month) + l(dates.first, :format => :year_end)
    else
      l(dates.first, :format => :long) + " - " + l(dates.last, :format => :long)
    end
  end

  private
  def same_day?(date_one, date_two)
    date_one.day == date_two.day
  end

  def same_month?(date_one, date_two)
    date_one.month == date_two.month
  end

  def same_year?(date_one, date_two)
    date_one.year == date_two.year
  end
end
