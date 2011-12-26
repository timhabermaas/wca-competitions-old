class WCA::Person < WCA::Base
  self.element_name = "persons"

  def results(params = {})
    WCA::Result.find(:all, :params => { :person_id => self.id }.merge(params))
  end

  def fastest_single_for(event)
    results(:event_id => event, :best => "single").first
  end

  def fastest_average_for(event)
    results(:event_id => event, :best => "average").first
  end
end
