require 'spec_helper'

describe Ability do
  subject { Ability.new(nil) }

  context "open competition" do
    let(:competition) { create :competition }

    it "should be able to register for open competitions" do
      should be_able_to(:new, Registration.new(:competition => competition))
      should be_able_to(:create, Registration.new(:competition => competition))
    end
  end

  context "closed competition" do
    let(:competition) { create :competition, :closed => true }

    it "should see registrations" do
      should be_able_to(:index, Registration.new(:competition => competition))
    end

    it "should not be able to register" do
      should_not be_able_to(:new, Registration.new(:competition => competition))
      should_not be_able_to(:create, Registration.new(:competition => competition))
    end
  end
end
