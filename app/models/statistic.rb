class Statistic
  def initialize(competition)
    @competition = competition
  end

  def events
    result = {}
    @competition.events.each do |event|
      result[event] = {
        :pros => @competition.registrations.with_wca_id.all.count { |r| r.competes_in? event },
        :noobs => @competition.registrations.without_wca_id.all.count { |r| r.competes_in? event } # TODO sqlify it
      }
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
