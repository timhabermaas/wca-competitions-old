module WCACompetitions
  module SpecHelper
    def create_registration(options = {})
      schedules = options.delete(:schedules) || []
      guest_days = options.delete(:guest_days) || []

      days = (guest_days + schedules.map(&:day)).uniq
      reg_days = days.map do |day|
        build(:registration_day, :day => day, :registration_id => nil)
      end

      options[:registration_days] = reg_days
      registration = create :registration, options

      registration.registration_days.each do |rd|
        schedules.each do |s|
          rd.schedules << s if rd.day == s.day
        end
        rd.save!
      end
      registration
    end
  end
end
