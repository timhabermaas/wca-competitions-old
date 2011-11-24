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
  end
end
