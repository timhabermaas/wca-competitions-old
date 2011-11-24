require 'spec_helper'

describe Competition do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :starts_at }
    it { should validate_presence_of :ends_at }

    it "validates uniqueness of name" do
      c1 = create(:competition)
      c2 = build(:competition, :name => c1.name)
      c2.should_not be_valid
      c2.errors[:name].should_not be_empty
    end

    it "starts before it ends" do
      competition = build(:competition, :starts_at => Date.new(2011, 2, 13),
                                        :ends_at => Date.new(2011, 2, 11))
      competition.should_not be_valid
      competition.errors[:ends_at].should_not be_empty
      competition = build(:competition, :starts_at => Date.new(2011, 2, 13),
                                        :ends_at => Date.new(2011, 2, 13))
      competition.should be_valid
    end
  end
end
