class Statistic
  def initialize(competition)
    @competition = competition
  end

  def events
    result = {}
    @competition.registrations.joins(:schedules).group("schedules.event_id").order("count_all DESC").count.each do |event_id, count|
      result[Event.find event_id] = count
    end
    result
  end

  def countries
    @competition.registrations.joins(:participant).group("participants.country").order("count_all DESC").count
  end

  def days
    result = {}
    @competition.days.each_with_index do |day, index|
      result[day] = { :competitors => @competition.registration_days.for(index).competitor.count,
                      :guests => @competition.registration_days.for(index).guest.count }
    end
    result
  end
end
