require "spec_helper"

describe WCA::Person do
  use_vcr_cassette "models/person", :record => :new_episodes

  it "finds Stefan Pochmann" do
    VCR.use_cassette "person/2003POCH01" do
      result = WCA::Person.find("2003POCH01")
      result.name.should == "Stefan Pochmann"
      result.countryId.should == "Germany"
    end
  end
end
