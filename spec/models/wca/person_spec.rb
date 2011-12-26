require "spec_helper"

describe WCA::Person do
  it "finds Stefan Pochmann" do
    VCR.use_cassette "person/2003POCH01" do
      result = WCA::Person.find("2003POCH01")
      result.name.should == "Stefan Pochmann"
      result.countryId.should == "Germany"
    end
  end

  it "gets Stefan Pochmann's best single for 3x3x3" do
    VCR.use_cassette "person/2003POCH01/single" do
      result = WCA::Person.find("2003POCH01").fastest_single_for("333") # TODO don't go through Person, Result also includes cached name and stuff
      result.average.should == 1721
      result.value4.should == 956
    end
  end

  it "gets Stefan Pochmann's best average for magic" do
    VCR.use_cassette "person/2003POCH01/average" do
      result = WCA::Person.find("2003POCH01").fastest_average_for("magic")
      result.average.should == 166
      result.value1.should == 143
    end
  end
end
