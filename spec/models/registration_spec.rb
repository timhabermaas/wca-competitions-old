require 'spec_helper'

describe Registration do
  describe "validations" do
    it { should validate_presence_of :competition_id }
    it { should validate_presence_of :competitor }
    it { should validate_presence_of :email }
  end
end
